# kalecky-types

Kaleckian GAMS modules (parameters / variables / equations / models) with an Idris 2 package stub.

## Layout

```
src/
├── parameters/   sets, parameters, expression macros
├── variables/    endogenous variables
├── equations/    equation declarations
└── models/       action models (Model / Solve hosts)
```

First action model: `src/models/ApplyMarkupThenPayWage.gms`
(markup → \(p\) → \(\Pi/Y\) → \(W/p\)).

## Commands

```bash
just gams parameters/Pricing.gms
just gams models/ApplyMarkupThenPayWage.gms
just type   # pack typecheck kalecky-types.ipkg
```

Listings go to `src/build/`.

## Docs

- GAMS 54: https://www.gams.com/54/docs/
- Idris 2: https://idris2.readthedocs.io/en/latest/
