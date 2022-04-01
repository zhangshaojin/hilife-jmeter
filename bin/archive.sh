#!/bin/bash

find ../out | grep "\.csv$" | xargs -I {} cp {} /Users/lihz/workspace/workspace_devops/devops-analyse-result
find ../out | grep "\.xlsx$" | xargs -I {} cp {} /Users/lihz/workspace/workspace_devops/devops-analyse-result