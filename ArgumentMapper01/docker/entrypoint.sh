#!/bin/sh

set -e

. ./env

dotnet ArgumentMapper.Api.dll
