package main

import (
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/prometheus/client_golang/prometheus"
)

func TestNewMetrics(t *testing.T) {
	reg := prometheus.NewRegistry()
	m := NewMetrics(reg)

	if m.cpuTemp == nil {
		t.Errorf("expected cpuTemp to be initialized, got nil")
	}

	if m.hdFailures == nil {
		t.Errorf("expected hdFailures to be initialized, got nil")
	}
}

func TestMetricsCPUTemp(t *testing.T) {
	reg := prometheus.NewRegistry()
	m := NewMetrics(reg)

	m.cpuTemp.Set(75.5)
	m.cpuTemp.Set(65.3)
	// Metrics are set successfully without panic
}

func TestMetricsHDFailures(t *testing.T) {
	reg := prometheus.NewRegistry()
	m := NewMetrics(reg)

	m.hdFailures.With(prometheus.Labels{"device": "/dev/sda"}).Inc()
	m.hdFailures.With(prometheus.Labels{"device": "/dev/sdb"}).Inc()
	// Metrics are incremented successfully without panic
}

func TestHealthHandlerContentType(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/health", nil)
	w := httptest.NewRecorder()

	healthHandler(w, req)

	if ct := w.Header().Get("Content-Type"); ct != "application/json" {
		t.Errorf("expected Content-Type application/json, got %s", ct)
	}
}

func TestItemsHandlerContentType(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/items", nil)
	w := httptest.NewRecorder()

	itemsHandler(w, req)

	if ct := w.Header().Get("Content-Type"); ct != "application/json" {
		t.Errorf("expected Content-Type application/json, got %s", ct)
	}
}

func TestItemsHandlerCount(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/items", nil)
	w := httptest.NewRecorder()

	itemsHandler(w, req)

	body, _ := io.ReadAll(w.Body)
	if !strings.Contains(string(body), "Item Two") {
		t.Errorf("expected 'Item Two' in response, got %s", string(body))
	}
}
func TestHealthHandler(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/health", nil)
	w := httptest.NewRecorder()

	healthHandler(w, req)

	if w.Code != http.StatusOK {
		t.Errorf("expected status %d, got %d", http.StatusOK, w.Code)
	}

	body, _ := io.ReadAll(w.Body)
	if !strings.Contains(string(body), "ok") {
		t.Errorf("expected 'ok' in response, got %s", string(body))
	}
}

func TestHealthHandlerMethodNotAllowed(t *testing.T) {
	req := httptest.NewRequest(http.MethodPost, "/health", nil)
	w := httptest.NewRecorder()

	healthHandler(w, req)

	if w.Code != http.StatusMethodNotAllowed {
		t.Errorf("expected status %d, got %d", http.StatusMethodNotAllowed, w.Code)
	}
}

func TestItemsHandler(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/items", nil)
	w := httptest.NewRecorder()

	itemsHandler(w, req)

	if w.Code != http.StatusOK {
		t.Errorf("expected status %d, got %d", http.StatusOK, w.Code)
	}

	body, _ := io.ReadAll(w.Body)
	if !strings.Contains(string(body), "Item One") {
		t.Errorf("expected 'Item One' in response, got %s", string(body))
	}
}

func TestItemsHandlerMethodNotAllowed(t *testing.T) {
	req := httptest.NewRequest(http.MethodDelete, "/items", nil)
	w := httptest.NewRecorder()

	itemsHandler(w, req)

	if w.Code != http.StatusMethodNotAllowed {
		t.Errorf("expected status %d, got %d", http.StatusMethodNotAllowed, w.Code)
	}
}

func TestHelperJSON(t *testing.T) {
	w := httptest.NewRecorder()
	data := map[string]string{"test": "value"}

	helperJSON(w, http.StatusOK, data)

	if w.Code != http.StatusOK {
		t.Errorf("expected status %d, got %d", http.StatusOK, w.Code)
	}

	if ct := w.Header().Get("Content-Type"); ct != "application/json" {
		t.Errorf("expected Content-Type application/json, got %s", ct)
	}
}
