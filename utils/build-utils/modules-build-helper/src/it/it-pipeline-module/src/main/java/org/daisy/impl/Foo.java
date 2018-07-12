package org.daisy.impl;

import org.osgi.service.component.annotations.Component;

@Component(
	name = "foo-service",
	service = { Runnable.class }
)
public class Foo implements Runnable {
	public void run() {
		System.out.print("hello world!");
	}
}
