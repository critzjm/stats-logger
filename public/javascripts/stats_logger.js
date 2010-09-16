var StatsLogger = {
  type: 'page_view',
  vid: null,
  logged_in: false,
  has_logged_in: false,
  referrer: document.referrer,
  userAgent: navigator.userAgent,
  pathName: window.location.pathname,
  queryString: window.location.search.substring(1),
  
  log: function() {
    params = { 
      type:this.type,
      vid:this.vid,
      logged_in: this.logged_in,
      has_logged_in: this.has_logged_in,
      referrer:this.referrer,
      user_agent:this.userAgent,
      path_name:this.pathName,
      query_string:this.queryString
    }
    $.get('http://localhost:3000/log', params);
  }
  
}
