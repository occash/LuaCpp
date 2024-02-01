#include <iostream>
#include <chrono>

#define W_EXPORT __declspec(dllexport)

class W_EXPORT Test
{
public:
    Test() : m_value(5) {}
    ~Test() {}

    static int add(int a, int b)
    {
        return a + b;
    }

    void test() const
    {
        std::cout << "Test: " << m_value << std::endl;
    }

    int value() const { return m_value; }
    void setValue(int value) { m_value = value; }

private:
    int m_value;

};

class W_EXPORT Test2 : public Test
{
public:
    double health;

    bool check(const Test &other) const
    {
        return value() == other.value();
    }

    static void lol()
    {
        Test2 t1, t2;
        t1.check(t2);
    }

private:
    float m_info1;
    short m_info2;

};

volatile static double _g = 3;

class W_EXPORT VTest
{
public:
    virtual void test() const
    {
        _g = _g * _g - _g;
    }

    static void call(VTest *t)
    {
        auto begin = std::chrono::high_resolution_clock::now();

        for (int i = 0; i < 10; ++i)
            t->test();

        auto end = std::chrono::high_resolution_clock::now();
        auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(end - begin);
        std::cout << elapsed.count() << "ms" << std::endl;
    }

};

class W_EXPORT VDTest : public VTest
{
public:
    void test() const override
    {
        std::cout << "VDTest" << std::endl;
    }
};