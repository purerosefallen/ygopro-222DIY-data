--盈泪之剑
function c65071073.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65071073,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65071073+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65071073.target)
	e1:SetOperation(c65071073.operation)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c65071073.deecon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65071073.deetg)
	e2:SetOperation(c65071073.deeop)
	c:RegisterEffect(e2)
end
function c65071073.deecon(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end

function c65071073.deefil(c)
	return c:IsCode(65071153)
end

function c65071073.deetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsCode(65071153) end
	if chk==0 then return Duel.IsExistingTarget(c65071073.deefil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectTarget(tp,c65071073.deefil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	local cg=tc:GetColumnGroup()
	cg:Merge(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,cg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end

function c65071073.hdcon(c,tp)
	return c:IsLocation(LOCATION_HAND) and c:IsControler(1-tp)
end

function c65071073.deeop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local cg=tc:GetColumnGroup()
		cg:AddCard(tc)
		if cg:GetCount()>0 then
			if Duel.SendtoHand(cg,nil,REASON_EFFECT)~=0 then
				local ct=cg:FilterCount(c65071073.hdcon,nil,tp)
				if ct>0 then
					Duel.BreakEffect()
					Duel.DiscardHand(1-tp,aux.TRUE,ct,ct,REASON_EFFECT+REASON_DISCARD)
				end
			end
		end
	end
end

function c65071073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c65071073.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,65071155,0,0x4011,2500,2000,8,RACE_SPELLCASTER,ATTRIBUTE_LIGHT,POS_FACEUP,tp) then return end
	local token=Duel.CreateToken(tp,65071155)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
		--cannot release
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		token:RegisterEffect(e2)
	   local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(1)
		token:RegisterEffect(e3)
	end
	Duel.SpecialSummonComplete()
		Duel.BreakEffect()
		e:GetHandler():CancelToGrave(true)
		Duel.Equip(tp,e:GetHandler(),token)
		local tc=e:GetHandler():GetEquipTarget()
		--Equip limit
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_EQUIP_LIMIT)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		e4:SetValue(1)
		c:RegisterEffect(e4)
		--give effect
		local e5=Effect.CreateEffect(c)
		e5:SetCategory(CATEGORY_COUNTER)
		e5:SetType(EFFECT_TYPE_QUICK_O)
		e5:SetCode(EVENT_FREE_CHAIN)
		e5:SetRange(LOCATION_MZONE)
		e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
		e5:SetCountLimit(1)
		e5:SetTarget(c65071073.addct)
		e5:SetOperation(c65071073.addc)
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e0:SetRange(LOCATION_SZONE)
		e0:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e0:SetReset(RESET_EVENT+0x1fe0000)
		e0:SetTarget(c65071073.eftg)
		e0:SetLabelObject(e5)
		c:RegisterEffect(e0)
		 --indes
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_SET_ATTACK_FINAL)
		e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e6:SetValue(4000)
		e6:SetCondition(c65071073.indcon2)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e7:SetRange(LOCATION_SZONE)
		e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e7:SetReset(RESET_EVENT+0x1fe0000)
		e7:SetTarget(c65071073.eftg)
		e7:SetLabelObject(e6)
		c:RegisterEffect(e7)
		--indes
		local e8=Effect.CreateEffect(c)
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e8:SetRange(LOCATION_MZONE)
		e8:SetCondition(c65071073.indcon2)
		e8:SetValue(1)
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e9:SetRange(LOCATION_SZONE)
		e9:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e9:SetReset(RESET_EVENT+0x1fe0000)
		e9:SetTarget(c65071073.eftg)
		e9:SetLabelObject(e8)
		c:RegisterEffect(e9)
		local e10=Effect.CreateEffect(c)
		e10:SetType(EFFECT_TYPE_SINGLE)
		e10:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e10:SetRange(LOCATION_MZONE)
		e10:SetCondition(c65071073.indcon2)
		e10:SetValue(1)
		local e11=Effect.CreateEffect(c)
		e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e11:SetRange(LOCATION_SZONE)
		e11:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e11:SetReset(RESET_EVENT+0x1fe0000)
		e11:SetTarget(c65071073.eftg)
		e11:SetLabelObject(e10)
		c:RegisterEffect(e11)
		local e12=Effect.CreateEffect(c)
		e12:SetType(EFFECT_TYPE_SINGLE)
		e12:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e12:SetValue(4000)
		e12:SetCondition(c65071073.indcon2)
		local e13=Effect.CreateEffect(c)
		e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e13:SetRange(LOCATION_SZONE)
		e13:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e13:SetReset(RESET_EVENT+0x1fe0000)
		e13:SetTarget(c65071073.eftg)
		e13:SetLabelObject(e12)
		c:RegisterEffect(e13)
end

function c65071073.addct(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	local mc=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,mc)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x10da)
end
function c65071073.addc(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x10da,1)
		--indes
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetRange(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c65071073.indcon)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
	e:GetHandler():RegisterFlagEffect(65071073,RESET_EVENT+0x1ec0000,0,0)
end
function c65071073.indcon(e)
	return e:GetHandler():GetCounter(0x10da)>0
end

function c65071073.indcon2(e)
	return e:GetHandler():GetFlagEffect(65071073)~=0 and Duel.GetCounter(tp,LOCATION_MZONE,0,0x10da)==0 
end

function c65071073.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
