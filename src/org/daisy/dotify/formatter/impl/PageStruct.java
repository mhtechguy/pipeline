package org.daisy.dotify.formatter.impl;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Stack;

/**
 * Provides a page oriented structure
 * 
 * @author Joel Håkansson
 */
class PageStruct implements Iterable<PageSequence> {
	private final Stack<PageSequence> seqs;
	private final Stack<PageImpl> pages;
	private final Map<Integer, View<PageImpl>> volumeViews;

	PageStruct() {
		seqs = new Stack<>();
		pages = new Stack<>();
		volumeViews = new HashMap<>();
	}

	static String toString(List<Sheet> units) {
		StringBuilder debug = new StringBuilder();
		for (Sheet s : units) {
			debug.append("s");
			if (s.isBreakable()) {
				debug.append("-");
			}
		}
		return debug.toString();
	}

	boolean add(PageSequence seq) {
		return seqs.add(seq);
	}

	boolean empty() {
		return seqs.empty();
	}

	PageSequence peek() {
		return seqs.peek();
	}

	int size() {
		return seqs.size();
	}

	Stack<PageImpl> getPages() {
		return pages;
	}

	@Deprecated
	View<PageImpl> getPageView() {
		return new View<PageImpl>(pages, 0, pages.size());
	}

	@Deprecated
	View<PageImpl> getContentsInVolume(int volumeNumber) {
		return volumeViews.get(volumeNumber);
	}

	@Deprecated
	void setVolumeScope(int volumeNumber, int fromIndex, int toIndex) {
		View<PageImpl> pw = new View<PageImpl>(pages, fromIndex, toIndex);
		for (PageImpl p : pw.getItems()) {
			p.setVolumeNumber(volumeNumber);
		}
		volumeViews.put(volumeNumber, pw);
	}

	@Override
	public Iterator<PageSequence> iterator() {
		return seqs.iterator();
	}

}