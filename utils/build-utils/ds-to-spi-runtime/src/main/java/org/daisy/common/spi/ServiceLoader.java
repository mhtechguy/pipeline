package org.daisy.common.spi;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import com.google.common.collect.AbstractIterator;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ServiceLoader<S> implements Iterable<S> {
	
	private static final Logger logger = LoggerFactory.getLogger(ServiceLoader.class);
	
	private static final Map<Class<?>,ServiceLoader<?>> cache = new HashMap<Class<?>,ServiceLoader<?>>();
	
	public static <S> ServiceLoader<S> load(Class<S> serviceType) {
		ServiceLoader<S> loader;
		if (cache.containsKey(serviceType)) {
			loader = (ServiceLoader<S>)cache.get(serviceType);
		} else {
			loader = new ServiceLoader<S>(serviceType);
			cache.put(serviceType, loader);
		}
		return loader;
	}
	
	private Class<S> serviceType;
	private java.util.ServiceLoader<S> serviceLoader;
	
	private ServiceLoader(Class<S> serviceType) {
		this.serviceType = serviceType;
	}
	
	public Iterator<S> iterator() {
		return new AbstractIterator<S>() {
			Iterator<S> serviceIterator;
			public S computeNext() {
				if (serviceIterator == null) {
					try {
						if (serviceLoader == null) {
							serviceLoader = java.util.ServiceLoader.load(serviceType);
						}
						serviceIterator = serviceLoader.iterator();
					} catch (Throwable e) {
						logger.error("Failed to instantiate services", e);
						return endOfData();
					}
				}
				while (serviceIterator.hasNext()) {
					try {
						return serviceIterator.next();
					} catch (Throwable e) {
						logger.error("Failed to instantiate service", e);
					}
				}
				return endOfData();
			}
		};
	}
}
