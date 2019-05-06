using System.Text.RegularExpressions
#tool nuget:?package=NUnit.ConsoleRunner&version=3.4.0
#addin "Cake.Docker"
#addin "Cake.Git"
#addin "nuget:?package=Cake.Release&version=0.0.4"
// #addin nuget:https://repo.activated.io/repository/nuget-group?package=cakerelease&version=0.0.3

var target = Argument("target", "Default");
var configuration = Argument("configuration", "Release");
var buildDir = Directory("./src/ArgumentMapper.Api/bin") + Directory(configuration);

Task("Clean")
.Does(() =>
    {
    CleanDirectory(buildDir);
    });

Task("Restore-NuGet-Packages")
.IsDependentOn("Clean")
.Does(() =>
    {
    NuGetRestore("./src/Network.sln");
    });

Task("Build")
.IsDependentOn("Restore-NuGet-Packages")
.Does(() =>
    {
    MSBuild("./src/ArgumentMapper.sln", settings =>
        settings.SetConfiguration(configuration));
    });

Task("Test")
    .IsDependentOn("Build")
    .Does(() =>
    {
        var projects = GetFiles("./src/*/*.csproj");

        foreach(var project in projects)
        {
            DotNetCoreTest(
                project.FullPath,
                new DotNetCoreTestSettings()
                {
                    Configuration = configuration,
                    NoBuild = true
                });
        }
    });

Task("Default")
.IsDependentOn("Test");

Task("Release")
.IsDependentOn("Test")
.Does(() =>
{
    Release(new ReleaseOptions(){
        ProjectFile = "./src/ArgumentMapper.Api/ArgumentMapper.Api.csproj",
        OnRelease = (v) => {
            var settings = new ReleaseContext(){
                ReleaseVersion = v,
                GitReleaseComment = "Release version: " + v.ToString(),
                GitReleaseTag = $"v-" + v.ToString(),
                NextVersionPrefix = new SemanticVersion(v.Major,v.Minor, v.Patch + 1),
                NextVersionSuffix = "-SNAPSHOT",
                GitNextVersionComment = "Preparing for next development iteration",
                GitName = "Release",
                GitEmail = "release@noreply.org",
                PublishAction = () => {

                    var nugetUsername = Environment.GetEnvironmentVariable("NUGET_USERNAME");
                    var nugetPassword = Environment.GetEnvironmentVariable("NUGET_PASSWORD");

                    var imageName = "repo.something:10500/something/argumentmapper-api:" + v.ToString();
                    var buildSettings = new DockerImageBuildSettings();
                    buildSettings.Tag = new string[] {imageName};
                    buildSettings.BuildArg = new string[] {"NUGET_USERNAME=" + nugetUsername, "NUGET_PASSWORD=" + nugetPassword};
                    DockerBuild(buildSettings, ".");
                    DockerPush(imageName);

                }
            };

            return settings;
        }
    });
});

RunTarget(target);
