--灵子殖装-厚土甲
function c21520041.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520041,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetTarget(c21520041.eqtg)
	e1:SetOperation(c21520041.eqop)
	c:RegisterEffect(e1)
end
function c21520041.eqfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_LINK)
end
function c21520041.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then 
		if Duel.GetFlagEffect(tp,21520047)<1 then 
			return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c21520041.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) 
		else 
			return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c21520041.eqfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Group.CreateGroup()
	if Duel.GetFlagEffect(tp,21520047)<1 then
		g=Duel.SelectTarget(tp,c21520041.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	else
		g=Duel.SelectTarget(tp,c21520041.eqfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	end
	if g:GetFirst():GetControler()~=tp then
		Duel.RegisterFlagEffect(tp,21520047,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c21520041.splimit)
		Duel.RegisterEffect(e1,tp)
	end
end
function c21520041.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x494)
end
function c21520041.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if tc:GetControler()~=e:GetHandlerPlayer() and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then 
		Duel.SendtoGrave(c,REASON_EFFECT)
		return 
	end
	local lr=0
	if tc:IsType(TYPE_XYZ) then 
		lr=tc:GetRank()-c:GetLevel()
	else
		lr=tc:GetLevel()-c:GetLevel()
	end
	if lr>0 and tc:GetControler()~=e:GetHandlerPlayer() then Duel.Damage(tp,lr*500,REASON_RULE) end
--	Duel.Equip(tp,c,tc,true,true)
	Duel.Equip(tp,c,tc,true)
	local atk=c:GetTextAttack()
	local def=c:GetTextDefense()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	e4:SetValue(c21520041.eqlimit)
	e4:SetLabelObject(tc)
	c:RegisterEffect(e4)
	--control
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_SET_CONTROL)
	e5:SetValue(c21520041.ctval)
	e5:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e5)
--	Duel.EquipComplete()
	--atk & def up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(def)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520041,1))
	e3:SetType(EFFECT_TYPE_EQUIP+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c21520041.idescon)
	e3:SetCost(c21520041.idescost)
	e3:SetOperation(c21520041.idesop)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3)
end
function c21520041.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c21520041.ctval(e,c)
	return e:GetHandlerPlayer()
end
function c21520041.idescon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsOnField() and e:GetHandler():IsFaceup()
end
function c21520041.idescost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	Duel.DiscardDeck(tp,1,REASON_COST)
end
function c21520041.idesop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
end
