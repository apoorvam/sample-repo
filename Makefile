ALL_PACKAGES=$(shell go list ./... | grep -v "vendor")

SHA=$(shell git rev-list HEAD --max-count=1 --abbrev-commit)
TAG?=$(shell git tag -l --contains HEAD)
VERSION=$(TAG)

ifeq ($(VERSION),)
VERSION := latest
endif

#Go parameters
GOCMD=go
GOINSTALL=$(GOCMD) install
GOTEST=$(GOCMD) test
DEP=dep
.PHONY : all install vet fmt test lint build

all: build test fmt lint vet

setup: install
	@go get -u golang.org/x/lint/golint

install: 
	@$(DEP) ensure -v

build: install
	@$(GOINSTALL) -ldflags "-X main.version=$(VERSION)-$(SHA) -s"

ci: build fmt lint vet
	@go test -v $(ALL_PACKAGES) -race -coverprofile=coverage.txt -covermode=atomic

test: build
	@go test -v $(ALL_PACKAGES)

vet:
	@go vet $(ALL_PACKAGES)

fmt:
	@go fmt $(ALL_PACKAGES)

lint:
	@golint -set_exit_status $(ALL_PACKAGES)

precommit: build test fmt lint vet