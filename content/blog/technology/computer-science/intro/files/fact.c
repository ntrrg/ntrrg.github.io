// Returns the factorial of n.
int fact(int n) {
	int r = 1;

	while (n > 1)
		r *= n--;

	return r;
}
