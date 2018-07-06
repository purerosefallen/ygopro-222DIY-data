--白沢球的顶点
function c22220162.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c22220162.matfilter,1)
	c:EnableReviveLimit()
	--equip
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(22220162,0))
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTarget(c22220162.eqtg)
	e0:SetOperation(c22220162.eqop)
	c:RegisterEffect(e0)
	--unequip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22220162,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c22220162.sptg)
	e1:SetOperation(c22220162.spop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c22220162.reptg)
	e2:SetValue(c22220162.repval)
	e2:SetOperation(c22220162.repop)
	c:RegisterEffect(e2)
	--gain effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetCondition(c22220162.atkcon)
	e3:SetValue(c22220162.atkval)
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)  
	e4:SetRange(LOCATION_SZONE)  
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)  
	e4:SetTarget(c22220162.eftg)  
	e4:SetLabelObject(e3)  
	c:RegisterEffect(e4) 
	--eqlimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EQUIP_LIMIT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(c22220162.eqlimit)
	c:RegisterEffect(e5)
end
function c22220162.matfilter(c)
	return c:IsSetCard(0x50f) and not c:IsCode(22220162)
end
function c22220162.eqlimit(e,c)
	return c:IsSetCard(0x50f) or e:GetHandler():GetEquipTarget()==c
end
function c22220162.eqfilter(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and c:IsSetCard(0x50f) and ct2==0
end
function c22220162.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22220162.eqfilter(chkc) end
	if chk==0 then return c:GetFlagEffect(22220162)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c22220162.eqfilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c22220162.eqfilter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(22220162,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c22220162.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or (c:IsLocation(LOCATION_MZONE) and c:IsFacedown()) then return end
	if not tc:IsRelateToEffect(e) or not c22220162.eqfilter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,true) then return end
	aux.SetUnionState(c)
end
function c22220162.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22220162)==0 and Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(22220162,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c22220162.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c22220162.eftg(e,c)  
	return e:GetHandler():GetEquipTarget()==c  
end
function c22220162.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local bc=e:GetHandler():GetBattleTarget()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and bc and not bc:IsControler(e:GetHandler():GetControler())
end
function c22220162.atkval(e,c)
	return e:GetHandler():GetBattleTarget():GetAttack()
end
function c22220162.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x50f) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c22220162.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() and e:GetHandler():IsType(TYPE_EQUIP) and eg:IsExists(c22220162.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c22220162.repval(e,c)
	return c22220162.repfilter(c,e:GetHandlerPlayer())
end
function c22220162.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end