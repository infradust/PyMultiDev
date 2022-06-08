import pkg_resources
import re
import sys

try:
    from pkg_resources import packaging

    def version_parse(v):
        return packaging.version.parse(v)

except Exception as e:
    print("unable to import version from packaging {}".format(str(e)))
    from distutils.version import LooseVersion

    def version_parse(v):
        return LooseVersion(v)


op_cmp = {
    ('==', '>'): '>',
    ('==', '>='): '>=',
    ('==', '<'): '==',
    ('==', '<='): '==',
    ('==', '!='): '==',
    ('==', '~='): '~=',
    ('>=', '<'): '>=',
    ('>=', '<='): '>=',
    ('>=', '>'): '>',
    ('>=', '!='): '>=',
    ('>', '<'): '>',
    ('>', '<='): '>',
    ('>', '!='): '>',
    ('<', '<='): '<=',
    ('<', '!='): '<',
    ('~=', '>='): '>='
}

for k in list(op_cmp.keys()):
    rev = (k[1], k[0])
    if rev not in op_cmp:
        op_cmp[rev] = op_cmp[k]


re_name = re.compile("^--(?P<name>.*)--$")
re_extra = re.compile("^\[(?P<extra>.*)\]$")


def main():
    req_file = sys.argv[1]
    out_file = sys.argv[2]
    with open(req_file, 'r') as f:
        lines = [line.strip() for line in f.readlines() if line.strip() != '']

    pkgs = set()
    reqs = {}
    extras = {}
    for line in lines:
        m = re_name.match(line)
        if m is not None:
            pkgs.add(m.group('name'))
            continue
        m = re_extra.match(line)
        if m is not None:
            continue
        r = pkg_resources.Requirement.parse(line)
        req_key = r.name.lower()
        if req_key not in reqs:
            reqs[req_key] = set()
        if len(r.specs) == 0:
            reqs[req_key] = None
        if reqs[req_key] is not None:
            for spec in r.specs:
                reqs[req_key].add(spec)
        if len(r.extras) > 0:
            extras[req_key] = extras.get(req_key, set()) | set(r.extras)

    final = []
    for req, specs in reqs.items():
        if req in pkgs:
            continue
        e = ','.join(list(extras.get(req, set())))
        if e != '':
            e = f"[{e}]"

        if specs is None:
            final.append(f'{req}{e}')
        else:
            mx = None
            s = None
            for spec in specs:
                # v = LooseVersion(spec[1])
                v = spec[1]
                if mx is None or version_parse(mx) < version_parse(v):
                    mx, s = v, spec
                elif mx == v:
                    s = (op_cmp[(s[0], spec[0])], v)
            e = ','.join(list(extras.get(req, set())))
            if e != '':
                e = f"[{e}]"
            final.append(f"{req}{e}{s[0]}{s[1]}")

    new_reqs = "\n".join(final)
    with open(out_file, 'w') as f:
        f.write(new_reqs)


if __name__ == "__main__":
    main()
