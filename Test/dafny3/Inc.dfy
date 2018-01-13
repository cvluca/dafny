// RUN: %dafny /compile:0 /dprint:"%t.dprint" "%s" > "%t"
// RUN: %diff "%s.expect" "%t"

datatype cmd = Inc | Seq(cmd, cmd) | Repeat(cmd)
type state = int

// ---------- ORDINAL ----------
  
inductive predicate BigStep(c: cmd, s: state, t: state)
{
  match c
  case Inc =>
    t == s + 1
  case Seq(c0, c1) =>
    exists s' :: BigStep(c0, s, s') && BigStep(c1, s', t)
  case Repeat(body) =>
    s == t ||
    exists s' :: BigStep(body, s, s') && BigStep(c, s', t)
}

// ---- correct lemma

// empty proof, with induction
inductive lemma Monotonic0(c: cmd, s: state, t: state)
  requires BigStep(c, s, t)
  ensures s <= t
{
  // Dafny rocks
}

// manual proof, with induction
inductive lemma Monotonic1(c: cmd, s: state, t: state)
  requires BigStep(c, s, t)
  ensures s <= t
{
  match c
  case Inc =>
  case Seq(c0, c1) =>
    var s' :| BigStep(c0, s, s') && BigStep(c1, s', t);
    Monotonic1(c0, s, s');
    Monotonic1(c1, s', t);
  case Repeat(body) =>
    if s == t{
    } else {
      var s' :| BigStep(body, s, s') && BigStep(c, s', t);
      Monotonic1(body, s, s');
      Monotonic1(c, s', t);
    }
}

// empty proof, without induction
inductive lemma {:induction false} Monotonic2(c: cmd, s: state, t: state)
  requires BigStep(c, s, t)
  ensures s <= t  // error: this is not proved automatically
{
}

// manual proof, without induction
inductive lemma {:induction false} Monotonic3(c: cmd, s: state, t: state)
  requires BigStep(c, s, t)
  ensures s <= t
{
  match c
  case Inc =>
  case Seq(c0, c1) =>
    var s' :| BigStep(c0, s, s') && BigStep(c1, s', t);
    Monotonic3(c0, s, s');
    Monotonic3(c1, s', t);
  case Repeat(body) =>
    if s == t{
    } else {
      var s' :| BigStep(body, s, s') && BigStep(c, s', t);
      Monotonic3(body, s, s');
      Monotonic3(c, s', t);
    }
}

// ---- incorrect lemma

// empty proof, with induction
inductive lemma BadMonotonic0(c: cmd, s: state, t: state)
  requires BigStep(c, s, t)
  ensures s == t  // error: does not hold
{
}

// manual proof attempt, with induction
inductive lemma BadMonotonic1(c: cmd, s: state, t: state)
  requires BigStep(c, s, t)
  ensures s == t  // error: does not hold
{
  match c
  case Inc =>
  case Seq(c0, c1) =>
    var s' :| BigStep(c0, s, s') && BigStep(c1, s', t);
    BadMonotonic1(c0, s, s');
    BadMonotonic1(c1, s', t);
  case Repeat(body) =>
    if s == t{
    } else {
      var s' :| BigStep(body, s, s') && BigStep(c, s', t);
      BadMonotonic1(body, s, s');
      BadMonotonic1(c, s', t);
    }
}

// empty proof, without induction
inductive lemma {:induction false} BadMonotonic2(c: cmd, s: state, t: state)
  requires BigStep(c, s, t)
  ensures s == t  // error: does not hold
{
}

// manual proof attempt, without induction
inductive lemma {:induction false} BadMonotonic3(c: cmd, s: state, t: state)
  requires BigStep(c, s, t)
  ensures s == t  // error: does not hold
{
  match c
  case Inc =>
  case Seq(c0, c1) =>
    var s' :| BigStep(c0, s, s') && BigStep(c1, s', t);
    BadMonotonic3(c0, s, s');
    BadMonotonic3(c1, s', t);
  case Repeat(body) =>
    if s == t{
    } else {
      var s' :| BigStep(body, s, s') && BigStep(c, s', t);
      BadMonotonic3(body, s, s');
      BadMonotonic3(c, s', t);
    }
}

// ---------- nat ----------
  
inductive predicate NatBigStep[nat](c: cmd, s: state, t: state)
{
  match c
  case Inc =>
    t == s + 1
  case Seq(c0, c1) =>
    exists s' :: NatBigStep(c0, s, s') && NatBigStep(c1, s', t)
  case Repeat(body) =>
    s == t ||
    exists s' :: NatBigStep(body, s, s') && NatBigStep(c, s', t)
}

// ---- correct lemma

// empty proof, with induction
inductive lemma NatMonotonic0[nat](c: cmd, s: state, t: state)
  requires NatBigStep(c, s, t)
  ensures s <= t
{
  // Dafny rocks
}

// manual proof, with induction
inductive lemma NatMonotonic1[nat](c: cmd, s: state, t: state)
  requires NatBigStep(c, s, t)
  ensures s <= t
{
  match c
  case Inc =>
  case Seq(c0, c1) =>
    var s' :| NatBigStep(c0, s, s') && NatBigStep(c1, s', t);
    NatMonotonic1(c0, s, s');
    NatMonotonic1(c1, s', t);
  case Repeat(body) =>
    if s == t{
    } else {
      var s' :| NatBigStep(body, s, s') && NatBigStep(c, s', t);
      NatMonotonic1(body, s, s');
      NatMonotonic1(c, s', t);
    }
}

// empty proof, without induction
inductive lemma {:induction false} NatMonotonic2[nat](c: cmd, s: state, t: state)
  requires NatBigStep(c, s, t)
  ensures s <= t  // error: this is not proved automatically
{
}

// manual proof, without induction
inductive lemma {:induction false} NatMonotonic3[nat](c: cmd, s: state, t: state)
  requires NatBigStep(c, s, t)
  ensures s <= t
{
  match c
  case Inc =>
  case Seq(c0, c1) =>
    var s' :| NatBigStep(c0, s, s') && NatBigStep(c1, s', t);
    NatMonotonic3(c0, s, s');
    NatMonotonic3(c1, s', t);
  case Repeat(body) =>
    if s == t{
    } else {
      var s' :| NatBigStep(body, s, s') && NatBigStep(c, s', t);
      NatMonotonic3(body, s, s');
      NatMonotonic3(c, s', t);
    }
}

// ---- incorrect lemma

// empty proof, with induction
inductive lemma BadNatMonotonic0[nat](c: cmd, s: state, t: state)
  requires NatBigStep(c, s, t)
  ensures s == t  // error: does not hold
{
}

// manual proof attempt, with induction
inductive lemma BadNatMonotonic1[nat](c: cmd, s: state, t: state)
  requires NatBigStep(c, s, t)
  ensures s == t  // error: does not hold
{
  match c
  case Inc =>
  case Seq(c0, c1) =>
    var s' :| NatBigStep(c0, s, s') && NatBigStep(c1, s', t);
    BadNatMonotonic1(c0, s, s');
    BadNatMonotonic1(c1, s', t);
  case Repeat(body) =>
    if s == t{
    } else {
      var s' :| NatBigStep(body, s, s') && NatBigStep(c, s', t);
      BadNatMonotonic1(body, s, s');
      BadNatMonotonic1(c, s', t);
    }
}

// empty proof, without induction
inductive lemma {:induction false} BadNatMonotonic2[nat](c: cmd, s: state, t: state)
  requires NatBigStep(c, s, t)
  ensures s == t  // error: does not hold
{
}

// manual proof attempt, without induction
inductive lemma {:induction false} BadNatMonotonic3[nat](c: cmd, s: state, t: state)
  requires NatBigStep(c, s, t)
  ensures s == t  // error: does not hold
{
  match c
  case Inc =>
  case Seq(c0, c1) =>
    var s' :| NatBigStep(c0, s, s') && NatBigStep(c1, s', t);
    BadNatMonotonic3(c0, s, s');
    BadNatMonotonic3(c1, s', t);
  case Repeat(body) =>
    if s == t{
    } else {
      var s' :| NatBigStep(body, s, s') && NatBigStep(c, s', t);
      BadNatMonotonic3(body, s, s');
      BadNatMonotonic3(c, s', t);
    }
}

// ---------- coinductive ----------
  
copredicate CoBigStep(c: cmd, s: state, t: state)
{
  match c
  case Inc =>
    t == s + 1
  case Seq(c0, c1) =>
    exists s' :: CoBigStep(c0, s, s') && CoBigStep(c1, s', t)
  case Repeat(body) =>
    s == t ||
    exists s' :: CoBigStep(body, s, s') && CoBigStep(c, s', t)
}