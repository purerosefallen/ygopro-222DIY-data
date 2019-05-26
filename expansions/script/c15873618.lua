--心之怪盗团-Noir
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873618
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c)
	c:SetUniqueOnField(1,0,m)
	local e1=rsphh.ImmueFun(c,ATTRIBUTE_LIGHT)
	local e2=rsef.QO(c,nil,{m,0},1,nil,"tg",LOCATION_MZONE,nil,nil,rstg.target(Card.IsFaceup,nil,0,LOCATION_MZONE,1,2),cm.attop)
end
function cm.attop(e,tp)
	local g=rsgf.GetTargetGroup(Card.IsFaceup)
	if #g<=0 then return end
	local attall=0xff
	for tc in aux.Next(g) do
		local att=tc:GetAttribute()
		if attall&att~=0 then
			 attall=attall-att
		end
	end
	local att=Duel.AnnounceAttribute(tp,1,attall)
	for tc in aux.Next(g) do
		local e1=rsef.SV_CHANGE({e:GetHandler(),tc},"att",att,nil,rsreset.est)
	end
end

