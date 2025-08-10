



echo on
IF %ERRORLEVEL% NEQ 0 exit /B 1
xmllint test.xml
IF %ERRORLEVEL% NEQ 0 exit /B 1
rg \r %CONDA_PREFIX%\etc\conda\activate.d\libxml2_activate.sh & if %ERRORLEVEL% NEQ 1 (exit 0) else (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
rg \r %CONDA_PREFIX%\etc\conda\deactivate.d\libxml2_deactivate.sh & if %ERRORLEVEL% NEQ 1 (exit 0) else (exit 1)
IF %ERRORLEVEL% NEQ 0 exit /B 1
mkdir     "%PREFIX%\etc\xml"
IF %ERRORLEVEL% NEQ 0 exit /B 1
copy test_catalog.xml  "%PREFIX%\etc\xml\catalog"
IF %ERRORLEVEL% NEQ 0 exit /B 1
xmlcatalog "" "http://www.w3.org/2001/xml.xsd" | findstr /X "/C:file://test-uri-override"
IF %ERRORLEVEL% NEQ 0 exit /B 1
del  "%PREFIX%\etc\xml\catalog"
IF %ERRORLEVEL% NEQ 0 exit /B 1
xmlcatalog "" "test-id" | findstr /X "/C:No entry for URI test-id"
IF %ERRORLEVEL% NEQ 0 exit /B 1
xmlcatalog "test_catalog.xml" "test-id" | findstr /X "/C:file://test-uri"
IF %ERRORLEVEL% NEQ 0 exit /B 1
set  "XML_CATALOG_FILES=file://%CD:\=/%/test_catalog.xml"
IF %ERRORLEVEL% NEQ 0 exit /B 1
xmlcatalog "" "test-id" | findstr /X "/C:file://test-uri"
IF %ERRORLEVEL% NEQ 0 exit /B 1
xmlcatalog "" "http://www.w3.org/2009/01/xml.xsd" | findstr /X "/C:No entry for URI http://www.w3.org/2009/01/xml.xsd"
IF %ERRORLEVEL% NEQ 0 exit /B 1
exit /B 0
