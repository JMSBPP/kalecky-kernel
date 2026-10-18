type:
	pack typecheck kalecky-types.ipkg

# Compile a GAMS module under src/.
# Layered layout: parameters/, variables/, equations/ (models/ reserved for hosts).
# Usage:  just gams parameters/Pricing.gms
#         just gams variables/Production.gms
#         just gams equations/MarkUpMultiplier.gms
# Listing: src/build/<slashes_to_underscores>.lst
gams file:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p src/build
    f="{{file}}"
    f="${f#file=}"
    f="${f#src/}"
    out="build/$(echo "$f" | tr / _ | sed 's/\.gms$//').lst"
    cd src && gams "$f" action=ce o="$out" scrdir=build lo=3
