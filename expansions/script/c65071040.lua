--目灯
function c65071040.initial_effect(c)
	--attack target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c65071040.tgcon)
	e1:SetTarget(c65071040.tgtg)
	e1:SetOperation(c65071040.tgop)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65071040,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,65071040)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65071040.target)
	e2:SetOperation(c65071040.activate)
	c:RegisterEffect(e2)
end

function c65071040.atkfil(c,tp)
	return c:IsControler(tp) and c:IsFaceup()
end

function c65071040.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c65071040.atkfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65071040.atkfil,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c65071040.atkfil,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c65071040.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	   --destroy
		local e1=Effect.CreateEffect(tc)
		e1:SetDescription(aux.Stringid(65071040,0))
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_BATTLE_START)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetTarget(c65071040.destg)
		e1:SetOperation(c65071040.desop)
		tc:RegisterEffect(e1,true)
		if not tc:IsType(TYPE_EFFECT) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2,true)
		end
		tc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65071040,0))
	end
end
function c65071040.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if chk==0 then return tc and tc:IsFaceup() and tc~=c end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c65071040.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc:IsRelateToBattle() and tc~=c then Duel.Destroy(tc,REASON_EFFECT) end
end

function c65071040.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and (Duel.IsAbleToEnterBP() or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE))
end
function c65071040.tgfilter(c)
	return c:GetFlagEffect(65071040)==0
end
function c65071040.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65071040.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65071040.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c65071040.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c65071040.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_RISE_TO_FULL_HEIGHT)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetLabel(tc:GetRealFieldID())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ONLY_BE_ATTACKED)
		e2:SetReset(RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2,true)
		tc:RegisterFlagEffect(65071040,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,0)
	end
end
