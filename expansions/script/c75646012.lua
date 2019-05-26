--崩坏学园 无色辉火
function c75646012.initial_effect(c)
	--get effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(c75646012.con)
	e1:SetOperation(c75646012.op)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c75646012.con1)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c75646012.chaincon)
	e2:SetOperation(c75646012.chainop)
	c:RegisterEffect(e2)
end
function c75646012.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(0x2c0) and eg:IsContains(e:GetHandler())
end
function c75646012.con1(e)
	return e:GetHandler():IsSetCard(0x2c0)
end
function c75646012.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,75646012)
	local tp=e:GetHandlerPlayer()
	Duel.Damage(1-tp,500,REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c75646012.chaincon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c75646012.chainop(e,tp,eg,ep,ev,re,r,rp)
	local es=re:GetHandler()
	if es:IsSetCard(0x2c0) and es:IsType(TYPE_EQUIP) 
		and es:GetEquipTarget()==e:GetHandler() and re:IsActiveType(TYPE_SPELL) and ep==tp then
		if Duel.IsPlayerAffectedByEffect(e:GetHandler():GetControler(),75646210) then
			Duel.SetChainLimit(c75646012.chainlm)
		else
			Duel.SetChainLimit(aux.FALSE)
		end  
	end
end
function c75646012.chainlm(e,rp,tp)
	return tp==rp
end