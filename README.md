# Foretoken

An ETS-based implementation of the [token bucket algorithm](https://en.wikipedia.org/wiki/Token_bucket).

- [API Documentation](http://hexdocs.pm/foretoken/)
- [Hex package information](https://hex.pm/packages/foretoken)

[![Hex.pm](http://img.shields.io/hexpm/v/foretoken.svg)](https://hex.pm/packages/foretoken)
[![Build Status](https://travis-ci.org/skirino/foretoken.svg)](https://travis-ci.org/skirino/foretoken)
[![Coverage Status](https://coveralls.io/repos/github/skirino/foretoken/badge.svg?branch=master)](https://coveralls.io/github/skirino/foretoken?branch=master)

## Feature & Design

- ETS as bucket storage
- Direct access to ETS table to exploit concurrency
- On-demand creation of buckets
- Automatic cleanup of unused buckets
- Extremely simple API (only 1 public interface function): `Foretoken.take/4`.

## Compatibility notes

This package requires Erlang/OTP 20 (or later).
