module plut.commonevent;

struct CommonEvent(ElementType, ValueType) {
    ElementType element;
    ValueType oldValue;
    ValueType newValue;
};