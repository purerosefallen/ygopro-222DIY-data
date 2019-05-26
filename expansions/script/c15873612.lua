--心之怪盗团-Skull
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873612
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c)
	c:SetUniqueOnField(1,0,m)
	local e1=rsphh.ImmueFun(c,ATTRIBUTE_LIGHT)
	local e2=rscf.SetSpecialSummonProduce(c,LOCATION_HAND,cm.spcon)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(rscf.FilterFaceUp(Card.IsCode,m-1),tp,LOCATION_MZONE,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
end
