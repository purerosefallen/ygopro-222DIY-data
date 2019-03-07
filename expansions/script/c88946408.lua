--生死轮舞 安弥奈尔·演绎
if not pcall(function() require("expansions/script/c88946402") end) then require("script/c88946402") end
local m=88946408
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=rsef.QO(c,nil,{m,0},{1,m},"atk,def,th","tg",LOCATION_PZONE,nil,nil,rstg.target({cm.cfilter,"atk,def",LOCATION_MZONE }),cm.atkop)
	local e2,e7=rslrd.RitualFunction(c,m)
	local e3=rslrd.SummonLimitFunction(c)
	local e4=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,1},{1,m+100},"se,th","de",nil,nil,rstg.target(rsop.list(cm.thfilter,"th",LOCATION_DECK)),cm.thop)
	local e5=rsef.QO(c,nil,{m,1},{1,m+100},"se,th",nil,LOCATION_HAND,nil,rscost.costself(Card.IsDiscardable,"dish"),rstg.target(rsop.list(cm.thfilter,"th",LOCATION_DECK)),cm.thop)
	local e6=rslrd.RemoveFunction(c)
	cm.pendlumeffect={e1,e2}
	cm.monstereffect={e5,e6}
end
function cm.thop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	local b1=tc:IsAbleToHand()
	local b2=tc:IsType(TYPE_PENDULUM) and not tc:IsForbidden() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	local op=rsof.SelectOption(tp,b1,{m,1},b2,{m,2})
	if op==1 then 
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function cm.thfilter(c,e,tp)
	return c:IsSetCard(0x8964) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))))
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8964)
end
function cm.atkop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local tc=rscf.GetTargetCard()
	if not tc then return end
	local atk=tc:GetBaseAttack()
	local def=tc:GetBaseDefense()
	local final=atk+def
	local e1=rsef.SV_SET({c,tc},"atkf,deff",final,nil,rsreset.est_pend)
	if c:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end