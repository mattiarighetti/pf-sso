<master>
  <property name="doc(title)">@page_title@</property>
  <property name="context">@context@</property>

  The following application packages are not mounted anywhere.  You can delete an unmounted package by clicking the "delete" option.

  <ul>
   <if @packages_normal:rowcount@ ne 0>
    <multiple name="packages_normal">
     <li>@packages_normal.name@ (@packages_normal.package_key@): [<a href="@packages_normal.instance_delete_url@" onclick="return confirm('Are you sure you want to delete package @packages_normal.name@');">delete</a>]</li>
    </multiple>
   </if>
   <else>
     <li>There are no unmounted packages</li>
   </else>
  </ul>

  The following services are singleton packages and are usually not meant to be mounted anywhere.  Be careful not to delete a service that is in use as this can potentially break the system.

  <ul>
   <if @packages_singleton:rowcount@ ne 0>
    <multiple name="packages_singleton">
     <li>@packages_singleton.name@  (@packages_singleton.package_key@): [<a href="@packages_singleton.instance_delete_url@" onclick="return confirm('Are you sure you want to delete package @packages_singleton.name@');">delete</a>]</li>
    </multiple>
   </if>
   <else>
     <li>There are no unmounted singleton packages</li>
   </else>
  </ul>

