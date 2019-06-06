package test.java.com.mycompany.hello;

import static org.junit.Assert.*;

import com.mycompany.hello.HelloServlet;

import org.junit.Before;
import org.junit.Test;



public class HelloServletTest {

    private HelloServlet h;

   @Before
   public void setUp() throws Exception
   {
       h = new HelloServlet();
   }
   @Test
   public void testHelloServlet() 
   {
    assertEquals(h.hello_str, "Hello Servlet");
   }
}