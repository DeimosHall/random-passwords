#!/bin/bash

cargo build --release

cargo deb

cargo generate-rpm
