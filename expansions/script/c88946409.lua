--生死轮舞 拉克西斯·凝刻
if not pcall(function() require("expansions/script/c88946402") end) then require("script/c88946402") end
local m=88946409
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=rsef.QO(c,nil,{m,0},{1,m},nil,nil,LOCATION_PZONE,nil,rscost.cost(cm.cfilter,"th",LOCATION_ONFIELD,0,1,99,c),rstg.target(rsop.list(cm.putfilter,nil,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA)),cm.putop)
	local e2,e7=rslrd.RitualFunction(c,m,true)
	local e3=rslrd.SummonLimitFunction(c)
	local e4=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m+100},"tk,sp","de",nil,nil,cm.tktg,cm.tkop)
	local e5=rsef.QO(c,nil,{m,1},{1,m+100},"tk,sp","tg",LOCATION_HAND,nil,rscost.costself(Card.IsDiscardable,"dish"),cm.tktg,cm.tkop)
	local e6=rslrd.RemoveFunction(c)
	cm.pendlumeffect={e1,e2}
	cm.monstereffect={e5,e6}
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,0x4011,1050,1050,7,RACE_SPELLCASTER,ATTRIBUTE_LIGHT,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,0x4011,1050,1050,7,RACE_SPELLCASTER,ATTRIBUTE_LIGHT,POS_FACEUP) then return end
	local token=Duel.CreateToken(tp,m+1)
	rssf.SpecialSummon(token)
end
function cm.cfilter(c)
	return c:IsSetCard(0x8964) and c:IsAbleToHandAsCost() and c:IsFaceup()
end
function cm.putfilter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and c:IsSetCard(0x8964)
end
function cm.putop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.putfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end