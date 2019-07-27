@echo off

:: program below
goto program


:usage

echo.Usage: mapnik-config [OPTION]
echo.
echo.Known values for OPTION are:
echo.
echo.  -h --help         display this help and exit
echo.  -v --version      version information (MAPNIK_VERSION_STRING)
echo.  --version-number  version number (MAPNIK_VERSION) (new in 2.2.0)
echo.  --git-revision    git hash from "git rev-list --max-count=1 HEAD"
echo.  --git-describe    git decribe output (new in 2.2.0)
echo.  --fonts           default fonts directory
echo.  --input-plugins   default input plugins directory
echo.  --defines         pre-processor defines for Mapnik build (new in 2.2.0)
echo.  --prefix          Mapnik prefix [default $CONFIG_PREFIX]
echo.  --lib-name        Mapnik library name
echo.  --libs            library linking information
echo.  --dep-libs        library linking information for Mapnik dependencies
echo.  --ldflags         library paths (-L) information
echo.  --includes        include paths (-I) for Mapnik headers (new in 2.2.0)
echo.  --dep-includes    include paths (-I) for Mapnik dependencies (new in 2.2.0)
echo.  --cxxflags        c++ compiler flags and pre-processor defines (new in 2.2.0)
echo.  --cflags          all include paths, compiler flags, and pre-processor defines (for back-compatibility)
echo.  --cxx             c++ compiler used to build mapnik (new in 2.2.0)
echo.  --all-flags       all compile and link flags (new in 2.2.0)
echo.  --gdal-data       path to GDAL_DATA directory, if detected at build time (new in 3.0.16)
echo.  --proj-lib        path to PROJ_LIB directory, if detected at build time (new in 3.0.16)
echo.  --icu-data        path to ICU_DATA directory, if detected at build time (new in 3.0.16)
echo.
exit /B 0

:program
 
if "%~1"=="" (
    call :usage
    exit /B 1
)

:: loop over options
:nextarg
    
    if "%~1"=="--help" (
      call :usage
      goto check_next
    )
    if "%~1"=="-h" (
      call :usage
      goto check_next
    )

    if "%~1"=="-v" (
      echo %CONFIG_MAPNIK_VERSION_STRING%
      goto check_next
    )
    if "%~1"=="--version" (
      echo %CONFIG_MAPNIK_VERSION_STRING%
      goto check_next
    )

    if "%~1"=="--version-number" (
      echo %CONFIG_MAPNIK_VERSION%
      goto check_next
    )

    if "%~1"=="--git-revision" (
      echo %CONFIG_GIT_REVISION%
      goto check_next
    )

    if "%~1"=="--git-describe" (
      echo %CONFIG_GIT_DESCRIBE%
      goto check_next
    )

    if "%~1"=="--fonts" (
      echo %FONT_DIR%
      goto check_next
    )

    if "%~1"=="--input-plugins" (
      echo %PREFIX%/bin/plugins/input
      goto check_next
    )

    if "%~1"=="--defines" (
      echo. %CONFIG_MAPNIK_DEFINES%
      goto check_next
    )

    if "%~1"=="--prefix" (
      echo %PREFIX%
      goto check_next
    )

    if "%~1"=="--lib-name" (
      echo mapnik
      goto check_next
    )

    if "%~1"=="--libs" (
      echo %PREFIX%/lib/mapnik %PREFIX%/lib/mapnik-json %PREFIX%/lib/mapnik-wkt
      goto check_next
    )

    if "%~1"=="--dep-libs" (
      echo. %CONFIG_DEP_LIBS%
      goto check_next
    )

    if "%~1"=="--ldflags" (
      echo. %CONFIG_MAPNIK_LDFLAGS%
      goto check_next
    )

    if "%~1"=="--includes" (
      echo /I%PREFIX%/include
      goto check_next
    )

    if "%~1"=="--dep-includes" (
      echo. %CONFIG_DEP_INCLUDES%
      goto check_next
    )

    if "%~1"=="--cxxflags" (
      echo. %CONFIG_CXXFLAGS%
      goto check_next
    )

    if "%~1"=="--cflags" (
      echo /I%PREFIX%/include %CONFIG_DEP_INCLUDES% %CONFIG_MAPNIK_DEFINES% %CONFIG_CXXFLAGS%
      goto check_next
    )

    if "%~1"=="--cxx" (
      echo %CONFIG_CXX%
      goto check_next
    )

    if "%~1"=="--all-flags" (
      echo /I%PREFIX%/include %CONFIG_DEP_INCLUDES% %CONFIG_MAPNIK_DEFINES% %CONFIG_CXXFLAGS% %CONFIG_MAPNIK_LIBPATH% %CONFIG_MAPNIK_LIBNAME% %CONFIG_MAPNIK_LDFLAGS% %CONFIG_DEP_LIBS%
      goto check_next
    )

    if "%~1"=="--gdal-data" (
      echo.%CONFIG_MAPNIK_GDAL_DATA%
      goto check_next
    )

    if "%~1"=="--proj-lib" (
      echo.%CONFIG_MAPNIK_PROJ_LIB%
      goto check_next
    )

    if "%~1"=="--icu-data" (
      echo.%CONFIG_MAPNIK_ICU_DATA%
      goto check_next
    )

    :: that was an invalid option
    1>&2 echo unknown option %~1

    :check_next
    shift
    if not "%~1"=="" goto nextarg

