# Foretoken

An ETS-based implementation of the [token bucket algorithm](https://en.wikipedia.org/wiki/Token_bucket).

- [API Documentation](http://hexdocs.pm/foretoken/)
- [Hex package information](https://hex.pm/packages/foretoken)

[![Hex.pm](http://img.shields.io/hexpm/v/foretoken.svg)](https://hex.pm/packages/foretoken)
[![Build Status](https://travis-ci.org/skirino/foretoken.svg)](https://travis-ci.org/skirino/foretoken)
[![Coverage Status](https://coveralls.io/repos/github/skirino/foretoken/badge.svg?branch=master)](https://coveralls.io/github/skirino/foretoken?branch=master)

## Feature & Design

- Simplest possible API (only 1 public interface function: `Foretoken.take/5`)
- ETS as concurrently accessible bucket storage
- Bucket lifecycle management
    - On-demand creation of buckets (whch can be disabled)
    - Automatic cleanup of unused buckets

## Compatibility notes

This package requires Erlang/OTP 20 (or later).
