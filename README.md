# kalecky-semantics

A typed system for Kaleckian income distribution, in Haskell.

**Core value:** ill-formed economics must not type-check. Currencies,
dimensions, valuations and agents' expectation measures are type-level
distinctions; amounts are exact (Natural / Rational) — no floats anywhere.

The v1.0 end goal — the Blecker-Setterfield wage-setting equation —
composes from the library's own combinators with no ad-hoc glue:

```haskell
nominalWageGrowthFrom rm1 householdGap rm2 productivityGrowth ind inflation
  = growthRate ( applyResponse rm1 (evalGap householdGap)
               + applyResponse rm2 (rate productivityGrowth)
               + applyIndexation ind inflation )
```

## Layout

```
src/Kalecky/
├── Types/        Numerics (Scale), Currency, Valuation, Measure,
│   ├── Units/    Unit, MoneyUnit, LaborUnit, TimeUnit, CompoundUnit
│   └── Prices/   Price, PriceIndex, Wage
├── Operators/    Expectation, Gap, Delta, GrowthRate, Effect,
│                 Conflict, ResponseMultiplier, Indexation
└── Equations/    WageSetting
test/             mirrors src; test/should-fail/ holds compile-fail boundaries
notes/            the specification (INCOME_DISTRIBUTION.md)
```

## Build & verify

```sh
stack test                       # property laws + worked examples
scripts/check-compile-fail.sh    # every should-fail file must be rejected
```

## Status

v1.0 shipped: see `.planning/MILESTONES.md`. Planning artifacts live in
`.planning/` (GSD).
