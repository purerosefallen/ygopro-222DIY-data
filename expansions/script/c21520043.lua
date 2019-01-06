--灵子殖装-爆炎臂
function c21520043.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520043,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetTarget(c21520043.eqtg)
	e1:SetOperation(c21520043.eqop)
	c:RegisterEffect(e1)
end
function c21520043.eqfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_LINK)
end
function c21520043.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then 
		if Duel.GetFlagEffect(tp,21520047)<1 then 
			return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c21520043.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) 
		else 
			return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c21520043.eqfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Group.CreateGroup()
	if Duel.GetFlagEffect(tp,21520047)<1 then
		g=Duel.SelectTarget(tp,c21520043.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	else
		g=Duel.SelectTarget(tp,c21520043.eqfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	end
	if g:GetFirst():GetControler()~=tp then
		Duel.RegisterFlagEffect(tp,21520047,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c21520043.splimit)
		Duel.RegisterEffect(e1,tp)
	end
end
function c21520043.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x494)
end
function c21520043.eqop(e,tp,eg,ep,ev,re,r,rp)
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
	e4:SetValue(c21520043.eqlimit)
	e4:SetLabelObject(tc)
	c:RegisterEffect(e4)
	--control
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_SET_CONTROL)
	e5:SetValue(c21520043.ctval)
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
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520043,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c21520043.damcon)
	e3:SetCost(c21520043.damcost)
	e3:SetTarget(c21520043.damtg)
	e3:SetOperation(c21520043.damop)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3)
end
function c21520043.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c21520043.ctval(e,c)
	return e:GetHandlerPlayer()
end
function c21520043.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler():GetEquipTarget())
end
function c21520043.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) and eg:IsContains(e:GetHandler():GetEquipTarget()) end
	Duel.DiscardDeck(tp,1,REASON_COST)
end
function c21520043.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ec=e:GetHandler():GetEquipTarget()
	local bc=ec:GetBattleTarget()
	Duel.SetTargetCard(bc)
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c21520043.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=tc:GetAttack()
		if dam<0 then dam=0 end
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end
