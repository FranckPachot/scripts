set timing on
exec statspack.snap(i_snap_level=>7);
exec STATSPACK.MODIFY_STATSPACK_PARAMETER (i_snap_level=>7, i_instance_number=>null);
