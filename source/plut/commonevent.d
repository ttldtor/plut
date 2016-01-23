module plut.commonevent;

import az.core.az;

struct CommonEvent(ElementType, ValueType) {
    ElementType element;
    ValueType oldValue;
    ValueType newValue;
};

template ValueChangeEvent(ValueType) {
    alias ValueChangeEvent = CommonEvent!(Az, ValueType);
};