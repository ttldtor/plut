module plut.sizepolicy;

enum Policy {Fixed, Minimum, Maximum};

struct SizePolicy {
    Policy horizontal, vertical;
};