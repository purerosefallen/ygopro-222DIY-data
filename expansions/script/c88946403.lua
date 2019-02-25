--生死轮舞 塞娜蕾菈·约束
if not pcall(function() require("expansions/script/c88946402") end) then require("script/c88946402") end
local m=88946403
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=rsef.I(c,{m,0},{1,m},nil,nil,LOCATION_PZONE,nil,cm.cost,cm.tg,cm.op)
	local e2=rslrd.SummonLimitFunction(c,true)
	local e3=rsef.QO(c,EVENT_CHAINING,{m,1},{1,m+100},"sp",nil,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,cm.spcon,nil,cm.sptg,cm.spop)
	local e4=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,2},nil,"tg","tg,de",nil,nil,rstg.target(cm.tgfilter,"tg",LOCATION_ONFIELD,LOCATION_ONFIELD),cm.tgop)
	local e5,e6=rslrd.RitualFunction(c,m)
	cm.pendlumeffect={e1,e6}
	cm.monstereffect={e3,e4}
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc and loc&LOCATION_HAND ~=0 and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x8964)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function cm.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function cm.tgop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then Duel.SendtoGrave(tc,REASON_EFFECT) end
end
function cm.cfilter(c)
	return c:IsSetCard(0x8964) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoExtraP(tg,tp,REASON_COST)
end
function cm.cfilter2(c,code)
	return not c:IsCode(code) and c:IsType(TYPE_MONSTER)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_HAND,0,1,e:GetHandler(),e:GetHandler():GetOriginalCode()) end
end
function cm.op(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_HAND,0,1,1,nil,c:GetOriginalCode()):GetFirst()
	if not tc then return end
	Duel.ConfirmCards(1-tp,tc)
	local e1=rsef.SV_ADD({c,tc},"code",c:GetOriginalCode(),nil,rsreset.est_pend-RESET_TOFIELD)
end