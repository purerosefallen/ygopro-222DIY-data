--钢铁花架 雷电芽衣
function c75646059.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3,c75646059.ovfilter,aux.Stringid(75646059,0),3,c75646059.xyzop)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c75646059.remcon)
	e1:SetTarget(c75646059.remtg)
	e1:SetOperation(c75646059.remop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75646059,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCost(c75646059.cost)
	e2:SetTarget(c75646059.tg)
	e2:SetOperation(c75646059.op)
	c:RegisterEffect(e2)
	c75646059.xyz_effect=e2
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c75646059.chaincon)
	e4:SetOperation(c75646059.chainop)
	c:RegisterEffect(e4)
end
function c75646059.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2c0) and c:IsType(TYPE_XYZ) and c:IsRank(4)
end
function c75646059.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,75646059)==0 end
	Duel.RegisterFlagEffect(tp,75646059,RESET_PHASE+PHASE_END,0,1)
end
function c75646059.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c75646059.remfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsAbleToRemove()
end
function c75646059.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c75646059.remfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75646059.remfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c75646059.remfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,g,1,0,0)
	Duel.SetChainLimit(c75646059.limit(g:GetFirst()))
end
function c75646059.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c75646059.remop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c75646059.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c75646059.filter(c)
	local eg=c:GetEquipGroup()
	return c:IsFaceup() and c:GetFlagEffect(75646059)==0 and eg:GetCount()==0
end
function c75646059.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c75646059.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75646059.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c75646059.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c75646059.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_MONSTER) and tc:GetFlagEffect(75646059)==0 then
		tc:RegisterFlagEffect(75646059,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(2800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		--immune spell
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetValue(c75646059.efilter)
		tc:RegisterEffect(e2)
	end
end
function c75646059.efilter(e,te)
	return te:GetHandler():IsType(TYPE_EQUIP)
end
function c75646059.chaincon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c75646059.chainop(e,tp,eg,ep,ev,re,r,rp)
	local es=re:GetHandler()
	if es:IsSetCard(0x2c0) and es:IsType(TYPE_EQUIP) 
		and es:GetEquipTarget()==e:GetHandler() and re:IsActiveType(TYPE_SPELL) and ep==tp then
		if Duel.IsPlayerAffectedByEffect(e:GetHandler():GetControler(),75646210) then
			Duel.SetChainLimit(c75646059.chainlm)
		else
			Duel.SetChainLimit(aux.FALSE)
		end	 
	end
end
function c75646059.chainlm(e,rp,tp)
	return tp==rp
end