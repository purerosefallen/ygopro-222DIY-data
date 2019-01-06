--灵子殖装-追风靴
function c21520044.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520044,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetTarget(c21520044.eqtg)
	e1:SetOperation(c21520044.eqop)
	c:RegisterEffect(e1)
end
function c21520044.eqfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_LINK)
end
function c21520044.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then 
		if Duel.GetFlagEffect(tp,21520047)<1 then 
			return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c21520044.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) 
		else 
			return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c21520044.eqfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Group.CreateGroup()
	if Duel.GetFlagEffect(tp,21520047)<1 then
		g=Duel.SelectTarget(tp,c21520044.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	else
		g=Duel.SelectTarget(tp,c21520044.eqfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	end
	if g:GetFirst():GetControler()~=tp then
		Duel.RegisterFlagEffect(tp,21520047,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c21520044.splimit)
		Duel.RegisterEffect(e1,tp)
	end
end
function c21520044.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x494)
end
function c21520044.eqop(e,tp,eg,ep,ev,re,r,rp)
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
	e4:SetValue(c21520044.eqlimit)
	e4:SetLabelObject(tc)
	c:RegisterEffect(e4)
	--control
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_SET_CONTROL)
	e5:SetValue(c21520044.ctval)
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
	--chain battle
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520044,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
--	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c21520044.cbcon)
	e3:SetCost(c21520044.cbcost)
	e3:SetTarget(c21520044.cbtg)
	e3:SetOperation(c21520044.cbop)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3)
end
function c21520044.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c21520044.ctval(e,c)
	return e:GetHandlerPlayer()
end
function c21520044.cbcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler():GetEquipTarget()) and e:GetHandler():GetEquipTarget()==Duel.GetAttacker()
end
function c21520044.cbcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) and eg:IsContains(e:GetHandler():GetEquipTarget()) end
	Duel.DiscardDeck(tp,1,REASON_COST)
end
function c21520044.cbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
--[[	local ec=e:GetHandler():GetEquipTarget()
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	ec:RegisterEffect(e2)--]]
	e:GetHandler():RegisterFlagEffect(21520044,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c21520044.cbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local ct=c:GetFlagEffect(21520044)-c:GetAttackedCount()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(ct)
	ec:RegisterEffect(e1)
end
