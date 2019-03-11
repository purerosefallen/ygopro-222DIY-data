--拟魂 阿赖耶识
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=18005001
local cm=_G["c"..m]
if not rsv.PseudoSoul then
	rsv.PseudoSoul={} 
	rsps=rsv.PseudoSoul
function rsps.EndPhasePFun(c,type2)
	aux.EnablePendulumAttribute(c)
	local cate=not type2 and "th,se" or "th"
	local operation=not type2 and rsps.thop1 or rsps.thop2
	local e1=rsef.FTF(c,EVENT_PHASE+PHASE_END,{m,1},1,cate,nil,LOCATION_PZONE,nil,nil,rsps.thtg,operation)
	return e1
end
function rsps.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function rsps.setfilter(c)
	return c:IsSSetable() and c:CheckSetCard("PseudoSoul") and c:GetType()==TYPE_CONTINUOUS+TYPE_TRAP 
end
function rsps.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:CheckSetCard("PseudoSoul") and c:IsAbleToHand()
end
function rsps.thop2(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c or Duel.SendtoHand(c,nil,REASON_EFFECT)<=0 or not c:IsLocation(LOCATION_HAND) then return end
	local g=Duel.GetMatchingGroup(rsps.setfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SSet(tp,sg:GetFirst())
		Duel.ConfirmCards(1-tp,sg)
	end
end
function rsps.thop1(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c or Duel.SendtoHand(c,nil,REASON_EFFECT)<=0 or not c:IsLocation(LOCATION_HAND) then return end
	local g=Duel.GetMatchingGroup(rsps.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function rsps.EndPhaseMFun(c)
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	local e1=rscf.SetSummonCondition(c,true)
end
function rsps.mthcon(e)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function rsps.FieldToHandFun(c)
	local e1=rsef.STO(c,EVENT_TO_HAND,{m,0},nil,"th","de",rsps.mthcon,nil,rstg.target(rsop.list(Card.IsAbleToHand,"th",0,LOCATION_ONFIELD,1)),rsps.mthop)
end
function rsps.mthop(e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #tg>0 then
		Duel.HintSelection(tg)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function rsps.SummonSucessFun(c,code,cate,costcount,tg,op)
	local e1=rsef.STO(c,EVENT_SUMMON_SUCCESS,{code,1},nil,cate,"de",nil,rsps.sscost(costcount),tg,op)
	return e1
end
function rsps.cfilter(c)
	return c:IsAbleToHandAsCost() and c:IsFaceup() and c:CheckSetCard("PseudoSoul")
end
function rsps.sscost(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return ct==0 or Duel.IsExistingMatchingCard(rsps.cfilter,tp,LOCATION_EXTRA,0,ct,nil) end
		if ct>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=Duel.SelectMatchingCard(tp,rsps.cfilter,tp,LOCATION_EXTRA,0,ct,ct,nil)
			Duel.SendtoHand(tg,nil,REASON_COST)
		end
	end
end
function rsps.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else
		return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	end
end
function rsps.sumfilter(c,e,tp)
	return c:CheckSetCard("PseudoSoul") and not c:IsCode(e:GetHandler():GetCode()) and c:IsSummonable(true,nil)
end
function rsps.MBPSummonFun(c)
	local e1=rsef.QO(c,nil,{m,1},1,"sum",nil,LOCATION_MZONE,rsps.sumcon,nil,rstg.target(rsop.list(rsps.sumfilter,"sum",LOCATION_HAND)),rsps.sumop)
end
function rsps.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,rsps.sumfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
function rsps.oscon(e,tp,eg)
	local f=function(c,p)
		return c:CheckSetCard("PseudoSoul") and c:IsFaceup() and c:IsControler(p)
	end
	return eg:IsExists(f,1,e:GetHandler(),tp)
end
function rsps.OtherSummonFun(c,code,cate,tg,op,filter,customop)
	local operation=not customop and rsps.osop(op,filter) or op
	local e1=rsef.FTO(c,EVENT_SUMMON_SUCCESS,{m,0},{1,code},cate,"de",LOCATION_MZONE,rsps.oscon,nil,tg,operation)
	return e1
end
function rsps.osfilter(c,tp,filter)
	return c:IsAbleToHand() and (not filter or filter(c,tp))
end
function rsps.osop(op,filter)
	return function(e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tg=Duel.SelectMatchingCard(tp,rsps.osfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp,filter)
		if #tg>0 then
			Duel.HintSelection(tg)
		end
		if Duel.SendtoHand(tg,nil,REASON_EFFECT)>0 and tg:GetFirst():IsLocation(LOCATION_HAND) then
			op(e,tp)
		end
	end
end
function rsps.trapcon(e)
	local f=function(c)
		return c:IsFaceup() and not c:CheckSetCard("PseudoSoul")
	end
	local tp=e:GetHandlerPlayer()
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_DISABLE) or e:GetHandler():IsHasEffect(EFFECT_CANNOT_DISABLE) then return true end
	return not Duel.IsExistingMatchingCard(f,tp,LOCATION_ONFIELD,0,1,nil)
end
function rsps.TrapRemoveFun(c)
	local e1=rsef.FTF(c,EVENT_PHASE+PHASE_STANDBY,{m,2},1,"rm",nil,LOCATION_SZONE,rsps.rmcon,nil,rsps.rmtg,rsps.rmop)
end
function rsps.pactfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:CheckSetCard("PseudoSoul") and c:GetActivateEffect():IsActivatable(tp)
end
function rsps.rmcon(e,tp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)>0
end
function rsps.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function rsps.rmop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)>0 and c:IsLocation(LOCATION_REMOVED) and Duel.IsExistingMatchingCard(rsps.pactfilter,tp,LOCATION_HAND,0,1,nil,tp) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.SelectYesNo(tp,aux.Stringid(m,7)) then
		local maxct=0
		if Duel.CheckLocation(tp,LOCATION_PZONE,0) then maxct=maxct+1 end
		if Duel.CheckLocation(tp,LOCATION_PZONE,1) then maxct=maxct+1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local ag=Duel.SelectMatchingCard(tp,rsps.pactfilter,tp,LOCATION_HAND,0,1,maxct,nil,tp)
		for tc in aux.Next(ag) do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
end
--------------------------------
end
--------------------------------
if cm then
cm.rssetcode="PseudoSoul"
function cm.initial_effect(c)
	rsps.EndPhasePFun(c,true)
	rsps.EndPhaseMFun(c)
	rsps.FieldToHandFun(c)
	rsps.SummonSucessFun(c,m,nil,1,rstg.target(rsop.list(cm.afilter,nil,LOCATION_DECK)),cm.op)
end
function cm.afilter(c,e,tp)
	return c:GetType()==TYPE_CONTINUOUS+TYPE_TRAP and c:CheckSetCard("PseudoSoul") and c:GetActivateEffect():IsActivatable(tp)
end
function cm.op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.afilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end
end
--------------------------
end
