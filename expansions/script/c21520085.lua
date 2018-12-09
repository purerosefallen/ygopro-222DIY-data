--玄翼战影
function c21520085.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_DARK),1)
	c:EnableReviveLimit()
	--atk & def
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520085,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c21520085.adcon)
	e1:SetCost(c21520085.adcost)
	e1:SetOperation(c21520085.adop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c21520085.atkval)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520085,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCondition(c21520085.damcon)
	e3:SetTarget(c21520085.damtg)
	e3:SetOperation(c21520085.damop)
	c:RegisterEffect(e3)
	--extra attack chance
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21520085,2))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetHintTiming(TIMING_BATTLE_STEP_END)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c21520085.exatkcon)
	e4:SetCost(c21520085.exatkcost)
	e4:SetOperation(c21520085.exatkop)
	c:RegisterEffect(e4)
end
function c21520085.adcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c21520085.adfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost()
end
function c21520085.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520085.adfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21520085.adfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:KeepAlive()
	e:SetLabelObject(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c21520085.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject():GetFirst()
	if c:IsRelateToEffect(e) then
		local atk=tc:GetTextAttack()
		local def=tc:GetTextDefense()
		if atk<0 then atk=0 end
		if def<0 then def=0 end
		--atk & def
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(def)
		c:RegisterEffect(e2)
		local g=Duel.GetMatchingGroup(c21520085.tdfilter,tp,LOCATION_GRAVE,0,nil,c:GetAttack())
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(21520085,3)) then
			Duel.BreakEffect()
			Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=g:Select(tp,1,c::GetMaterialCount(),nil)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end
end
function c21520085.tdfilter(c,atk)
	return c:IsAbleToDeck() --and c:IsAttackBelow(atk) and c:IsType(TYPE_MONSTER) and not c:IsAttribute(ATTRIBUTE_DARK)
end
function c21520085.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsAttribute,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,ATTRIBUTE_DARK)*100
end
function c21520085.damcon(e,tp,eg,ep,ev,re,r,rp)
	local gc=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	local dgc=Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_DARK)
	return gc==dgc and gc>0
end
function c21520085.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dgc=Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_DARK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dgc*200)
end
function c21520085.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local dgc=Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_DARK)
		Duel.Damage(1-tp,dgc*200,REASON_EFFECT)
	end
end
function c21520085.exatkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return e:GetHandler():GetAttackedCount()>0 and tp==e:GetHandler():GetControler() and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE --and e:GetHandler():GetFlagEffect(21520085)~=0
end
function c21520085.exatkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520085.adfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21520085.adfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:KeepAlive()
	e:SetLabelObject(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c21520085.exatkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject():GetFirst()
	if c:IsRelateToEffect(e) then
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		--atk & def
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(c:GetAttackedCount())
		c:RegisterEffect(e2)
	end
end
