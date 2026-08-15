/// Maps a 0–10 visible score to one of four bands.
///
/// Per the Detoxia V1 spec:
///   - Low      : 0.0 ≤ score < 2.5
///   - Mild     : 2.5 ≤ score < 5.0
///   - Moderate : 5.0 ≤ score < 7.5
///   - High     : 7.5 ≤ score ≤ 10.0
///
/// Boundary convention: strict `<` on the upper bound for every band except
/// `High`. So `2.4 → Low`, `2.5 → Mild`, `4.9999 → Mild`, `5.0 → Moderate`,
/// `7.5 → High`, `10.0 → High`.
String scoreBand(double score) {
  if (score < 2.5) return 'Low';
  if (score < 5.0) return 'Mild';
  if (score < 7.5) return 'Moderate';
  return 'High';
}
