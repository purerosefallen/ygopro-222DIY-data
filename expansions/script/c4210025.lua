--猫耳天堂-La Soleil
function c4210025.initial_effect(c)
	c:EnableCounterPermit(0x2af)
	c:SetCounterLimit(0x2af,9)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk
	local atk=Effect.CreateEffect(c)
	atk:SetType(EFFECT_TYPE_FIELD)
	atk:SetCode(EFFECT_UPDATE_ATTACK)
	atk:SetRange(LOCATION_FZONE)
	atk:SetTargetRange(LOCATION_MZONE,0)
	atk:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2af))
	atk:SetValue(function(e,c) return Duel.GetMatchingGroupCount(function(c,e) return c:IsSetCard(0x2af)and c:IsType(TYPE_MONSTER) end,c:GetControler(),LOCATION_REMOVED,0,nil)*150 end)
	c:RegisterEffect(atk)
	--def
	local def=Effect.CreateEffect(c)
	def:SetType(EFFECT_TYPE_FIELD)
	def:SetCode(EFFECT_UPDATE_DEFENSE)
	def:SetRange(LOCATION_FZONE)
	def:SetTargetRange(LOCATION_MZONE,0)
	def:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2af))
	def:SetValue(function(e,c) return Duel.GetMatchingGroupCount(function(c,e) return c:IsSetCard(0x2af)and c:IsType(TYPE_MONSTER) end,c:GetControler(),LOCATION_REMOVED,0,nil)*150 end)
	c:RegisterEffect(def)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(function(e,c) return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2af) end)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--add counter
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_REMOVE)
	e5:SetOperation(c4210025.ctop)
	c:RegisterEffect(e5)
	--destroy replace
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTarget(c4210025.reptg)
	e6:SetValue(c4210025.repval)
	e6:SetOperation(c4210025.repop)
	c:RegisterEffect(e6)
end
function c4210025.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsPreviousLocation(0x80+LOCATION_SZONE) and not c:IsType(TYPE_TOKEN)
end
function c4210025.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c4210025.ctfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x2af,ct)
		Duel.Recover(tp,300*ct,REASON_EFFECT) 
	end
end
function c4210025.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x2af) and c:IsControler(tp) 
		and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c4210025.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x2af)>=3 and eg:IsExists(c4210025.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c4210025.repval(e,c)--c is not exgit
	return c4210025.repfilter(c,e:GetHandlerPlayer()) --and (bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0)
end
function c4210025.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x2af,3,REASON_EFFECT)
end