--夜鸦·TGSX-Ⅱ
if not pcall(function() require("expansions/script/c10114001") end) then require("script/c10114001") end
local m=10114005
local cm=_G["c"..m]
function cm.initial_effect(c)
	nrrsv.NightRavenSpecialSummonRule(c,6)
	nrrsv.NightRavenSpecialSummonEffect(c,CATEGORY_SPECIAL_SUMMON,cm.rmtg,cm.rmop)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,1-tp,LOCATION_DECK)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	local g=Duel.GetDecktopGroup(1-tp,3)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end