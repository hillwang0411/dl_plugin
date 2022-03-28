#!/bin/bash
bazelisk build  -c opt --experimental_repo_remote_exec //tensorflow_plugin/tools/pip_package:build_pip_package --verbose_failures
