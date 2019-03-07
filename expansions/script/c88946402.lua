--生死轮舞 帕可莉诺·镜花
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=88946402
local cm=_G["c"..m]
if not rsv.LifeDeathRoundDance then
	rsv.LifeDeathRoundDance={}
	rslrd=rsv.LifeDeathRoundDance
function rslrd.RitualFunction(c,code,isextra)
	local range=LOCATION_PZONE+LOCATION_HAND+LOCATION_GRAVE 
	if isextra then range=LOCATION_PZONE+LOCATION_HAND+LOCATION_EXTRA end 
	local e1=rsef.I(c,{m,1},nil,"des,rm,sp",nil,LOCATION_PZONE,nil,nil,rslrd.rtg,rslrd.rop)
	local e2=rsef.QO(c,nil,{m,1},{1,code},"des,rm,sp",nil,LOCATION_PZONE,rslrd.rcon,nil,rslrd.rtg,rslrd.rop)
	e1:SetLabel(range)
	e2:SetLabel(range)
	return e1,e2
end
function rslrd.rcon(e,tp)
	return Duel.IsPlayerAffectedByEffect(tp,88946411) and Duel.GetTurnPlayer()~=tp
end
function rslrd.rcfilter(c,e,tp)
	if not c:IsSetCard(0x8964) then return false end
	if c:IsOnField() and not c:IsFaceup() then return false end
	if c:IsLocation(LOCATION_EXTRA) and not c:IsAbleToRemove() then return false end
	return Duel.IsExistingMatchingCard(rslrd.spfilter,tp,e:GetLabel(),0,1,c,e,tp,c)
end
function rslrd.spfilter(c,e,tp,rc)
	return c:GetOriginalType()&0x81==0x81 and c:IsSetCard(0x8964) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) and ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,rc)>0) or (not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp,rc,tp)>0))
end
function rslrd.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(rslrd.rcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_GRAVE)
end
function rslrd.rop(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=Duel.SelectMatchingCard(tp,rslrd.rcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA,0,1,1,c,e,tp)
	if #tg<=0 then return end
	local tc=tg:GetFirst()
	if tc:IsOnField() then Duel.HintSelection(tg) end
	local ct=0
	if tc:IsLocation(LOCATION_EXTRA) then ct=Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_RITUAL+REASON_MATERIAL) 
	else ct=Duel.Destroy(tc,REASON_EFFECT+REASON_RITUAL+REASON_MATERIAL)
	end 
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(rslrd.spfilter),tp,e:GetLabel(),0,1,1,tc,e,tp,tc):GetFirst()
	if sc then
		sc:SetMaterial(tg)
		Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
	end 
end
function rslrd.SummonLimitFunction(c,ctype)
	local e1=nil
	if ctype then
		e1=rscf.SetSummonCondition(c,true,rslrd.sumval)
	else
		e1=rscf.SetSummonCondition(c,false,rslrd.sumval)
	end
	return e1
end
function rslrd.sumval(e,se)
	return se and se:GetHandler():IsSetCard(0x8964)
end
function rslrd.RemoveFunction(c)
	local e1=rsef.STF(c,EVENT_DESTROYED,{m,3},nil,"rm,rec","dsp,cd,cn,de,dcal",rslrd.rmcon,nil,nil,rslrd.rmop)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	return e1
end 
function rslrd.rmcon(e)
	local c=e:GetHandler()
	local rc=c:GetReasonEffect():GetHandler()
	return not c:IsLocation(LOCATION_REMOVED) and c:IsReason(REASON_RITUAL) and c:IsReason(REASON_MATERIAL) and rc and rc:IsSetCard(0x8964) and c:IsPreviousLocation(LOCATION_MZONE)
end
function rslrd.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function rslrd.rmop(e,tp)
	local c=e:GetHandler()
	if not c or Duel.Remove(c,POS_FACEUP,REASON_EFFECT)<=0 or not c:IsLocation(LOCATION_REMOVED) then return end
	Duel.BreakEffect()
	Duel.Recover(tp,500,REASON_EFFECT)
end
function rslrd.dishcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() and Duel.IsExistingMatchingCard(rslrd.thcfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,rslrd.thcfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function rslrd.thcfilter(c)
	return c:IsDiscardable()
end
----------------
end
----------------
if cm then
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=rsef.I(c,{m,0},{1,m},nil,nil,LOCATION_PZONE,cm.con,nil,nil,cm.op)
	local e2=rsef.STO(c,EVENT_LEAVE_FIELD,{m,2},{1,m+100},"se,th","de,dsp,dcal",cm.thcon,nil,rstg.target(rsop.list(cm.thfilter,"th",LOCATION_GRAVE+LOCATION_DECK)),cm.thop)
	local e3,e4=rslrd.RitualFunction(c,m)
	cm.pendlumeffect={e1,e3}
	cm.monstereffect={e2}
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:GetActivateEffect():IsActivatable(tp)
		if b1 and (not b2 or Duel.SelectOption(tp,1190,1150)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
end
function cm.thfilter(c,e,tp)
	return c:IsSetCard(0x8964) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8964)
end
function cm.cfilter2(e,c)
	return c:IsFaceup() and c:IsSetCard(0x8964) and c:GetOwner()==e:GetHandlerPlayer()
end
function cm.con(e)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function cm.op(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local e1=rsef.FV_CANNOT_BE_TARGET({c,tp},"effect",aux.tgoval,cm.cfilter2,{LOCATION_ONFIELD,LOCATION_ONFIELD },nil,rsreset.pend)
end
--------------
end