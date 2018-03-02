--夜鸦·TGS-Ⅲ
if not pcall(function() require("expansions/script/c10114001") end) then require("script/c10114001") end
local m=10114003
local cm=_G["c"..m]
function cm.initial_effect(c)
	nrrsv.NightRavenSpecialSummonRule(c,5)
	nrrsv.NightRavenSpecialSummonEffect(c,CATEGORY_TOHAND,cm.thtg,cm.thop)
end
function cm.thfilter(c,e,tp)
	return c:IsSetCard(0x3331) and (c:IsAbleToHand() or ((c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or (c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable())))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	local setable=((tc:IsType(TYPE_TRAP+TYPE_SPELL) and tc:IsSSetable()) or (tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
	if setable and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
	   if tc:IsType(TYPE_MONSTER) then
		  Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	   else
		  Duel.SSet(tp,tc)
	   end
	else
	   Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	Duel.ConfirmCards(1-tp,tc)
end
