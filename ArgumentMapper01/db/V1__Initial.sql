
--ExternalAPIStagingData
CREATE TABLE [dbo].[ExternalAPIStagingData](
	[ExternalAPIStagingDataID] [int] IDENTITY(1,1) NOT NULL,
	[APIURL] [nvarchar](2000) NOT NULL,
	[JSONResult] [nvarchar](max) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ExternalAPIStagingData] PRIMARY KEY CLUSTERED 
(
	[ExternalAPIStagingDataID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GRANT SELECT, INSERT, UPDATE, DELETE ON ExternalAPIStagingData TO ${appuser};
GO
