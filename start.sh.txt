#!/bin/bash
export PATH=$(npm root -g)/pnpm/bin:$PATH
pnpm exec openclaw gateway --port $PORT --verbose
