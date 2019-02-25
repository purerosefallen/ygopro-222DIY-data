--生死轮舞 艾莫尼诺·沐光
if not pcall(function() require("expansions/script/c88946402") end) then require("script/c88946402") end
local m=88946407
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=rsef.FTO(c,EVENT_REMOVE,{m,0},{1,m},"des","tg,de",LOCATION_PZONE,cm.descon,nil,rstg.target({Card.IsFaceup,"des",0,LOCATION_ONFIELD }),cm.desop)
	local e2,e7=rslrd.RitualFunction(c,m,true)
	local e3=rslrd.SummonLimitFunction(c)
	local e4=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m+100},"tg","tg,de",nil,nil,rstg.target({aux.TRUE,"tg,th",LOCATION_REMOVED }),cm.tgop)
	local e5=rsef.QO(c,nil,{m,1},{1,m+100},"tg","tg",LOCATION_HAND,nil,rscost.costself(Card.IsDiscardable,"dish"),rstg.target({Card.IsFaceup,"tg",LOCATION_REMOVED }),cm.tgop)
	local e6=rslrd.RemoveFunction(c)
	cm.pendlumeffect={e1,e2}
	cm.monstereffect={e5,e6}
end
function cm.tgop(e,tp)
	local tc=rscf.GetTargetCard()
	if not tc or Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)<=0 or not tc:IsLocation(LOCATION_GRAVE) or not tc:IsType(TYPE_MONSTER) or not tc:IsSetCard(0x8964) then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function cm.descon(e,tp,eg)
	local f=function(c,p)
		return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==p and c:IsOriginalSetCard(0x8964)
	end
	return eg:IsExists(f,1,nil,tp)
end
function cm.desop(e)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local tc=rscf.GetTargetCard()
	if tc then Duel.Destroy(tc,REASON_EFFECT) end
end