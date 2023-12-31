<img align="right" width="150" height="150" top="100" src="./assets/logo.webp">

# Souls • [![ci](https://github.com/NaniDAO/souls/actions/workflows/ci.yml/badge.svg)](https://github.com/NaniDAO/souls/actions/workflows/ci.yml) ![license](https://img.shields.io/github/license/NaniDAO/souls?label=license) ![solidity](https://img.shields.io/badge/solidity-0.8.20-lightgrey)

A contract for managing "souls" associated with NFTs.

## Getting Started

## Blueprint

```ml
lib
├─ forge-std — https://github.com/foundry-rs/forge-std
└─ solbase — https://github.com/Sol-DAO/solbase
scripts
├─ Deploy.s.sol — Simple Deployment Script
src
└─ Souls.sol — Contains logic for reading and writing "soul" associated with NFT
test
└─ Souls.t — Exhaustive Tests
```

## Development

**Setup**

```bash
forge install
```

**Building**

```bash
forge build
```

**Testing**

```bash
forge test
```

**Deployment & Verification**

Inside the [`utils/`](./utils/) directory are a few preconfigured scripts that can be used to deploy and verify contracts.

Scripts take inputs from the cli, using silent mode to hide any sensitive information.

_NOTE: These scripts are required to be \_executable_ meaning they must be made executable by running `chmod +x ./utils/*`.\_

_NOTE: these scripts will prompt you for the contract name and deployed addresses (when verifying). Also, they use the `-i` flag on `forge` to ask for your private key for deployment. This uses silent mode which keeps your private key from being printed to the console (and visible in logs)._

### First time with Forge/Foundry?

See the official Foundry installation [instructions](https://github.com/foundry-rs/foundry/blob/master/README.md#installation).

Then, install the [foundry](https://github.com/foundry-rs/foundry) toolchain installer (`foundryup`) with:

```bash
curl -L https://foundry.paradigm.xyz | bash
```

Now that you've installed the `foundryup` binary,
anytime you need to get the latest `forge` or `cast` binaries,
you can run `foundryup`.

So, simply execute:

```bash
foundryup
```

🎉 Foundry is installed! 🎉

### Writing Tests with Foundry

With [Foundry](https://github.com/foundry-rs/foundry), all tests are written in Solidity! 🥳

Create a test file for your contract in the `test/` directory.

For example, [`src/Greeter.sol`](./src/Greeter.sol) has its test file defined in [`./test/Greeter.t.sol`](./test/Greeter.t.sol).

To learn more about writing tests in Solidity for Foundry, reference Rari Capital's [solmate](https://github.com/Rari-Capital/solmate/tree/main/src/test) repository created by [@transmissions11](https://twitter.com/transmissions11).

### Configure Foundry

Using [foundry.toml](./foundry.toml), Foundry is easily configurable.

For a full list of configuration options, see the Foundry [configuration documentation](https://github.com/foundry-rs/foundry/blob/master/config/README.md#all-options).

## License

[MIT](https://github.com/NaniDAO/souls/blob/master/LICENSE)

## Acknowledgements

- [femplate](https://github.com/abigger87/femplate)
- [kplate](https://github.com/kalidao/kplate)
- [foundry](https://github.com/foundry-rs/foundry)
- [solbase](https://github.com/Sol-DAO/solbase)
- [forge-std](https://github.com/brockelmore/forge-std)
- [forge-template](https://github.com/foundry-rs/forge-template)
- [foundry-toolchain](https://github.com/foundry-rs/foundry-toolchain)

## Disclaimer

_These smart contracts are being provided as is. No guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of the user interface or the smart contracts. They have not been audited and as such there can be no assurance they will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. The creators are not liable for any of the foregoing. Users should proceed with caution and use at their own risk._
