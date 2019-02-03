--宁静圣珖
function c21520086.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_LIGHT),1)
	c:EnableReviveLimit()
	--atk & def
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520086,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c21520086.adcon)
	e1:SetOperation(c21520086.adop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(c21520086.discon)
	e2:SetOperation(c21520086.disop)
	c:RegisterEffect(e2)
	--disable(ignition)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520086,2))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c21520086.dis2tg)
	e3:SetOperation(c21520086.dis2op)
	c:RegisterEffect(e3)
end
function c21520086.adcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	return c:GetSummonType()&SUMMON_TYPE_SYNCHRO==SUMMON_TYPE_SYNCHRO and g:GetCount()==g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)
end
function c21520086.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(Card.IsAttribute,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,ATTRIBUTE_LIGHT)
--[[		local atk,def=0,0
		local check={}
		local tg=Group.CreateGroup()
		for tc in aux.Next(g) do
			for i,code in ipairs({tc:GetOriginalCode()}) do
				if not check[code] then
					check[code]=true
					tg:AddCard(tc)
				end
			end
		end
		for ac in aux.Next(tg) do
			atk=atk+ac:GetAttack()
			def=def+ac:GetDefense()
		end--]]
		--atk & def
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(g:GetCount()*500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function c21520086.disfilter(c)
	return not c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsFaceup()
end
function c21520086.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:GetHandler()~=e:GetHandler() and re:GetHandler():GetAttack()>0 
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) and not Duel.IsExistingMatchingCard(c21520086.disfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c21520086.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsFacedown() or c:GetAttack()<rc:GetAttack() or c:GetDefense()<rc:GetDefense() or c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	if Duel.SelectYesNo(tp,aux.Stringid(21520086,1)) then 
		Duel.Hint(HINT_CARD,rc:GetControler(),21520086)
		Duel.NegateEffect(ev)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-rc:GetAttack())
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-rc:GetDefense())
		c:RegisterEffect(e2)
	end
end
function c21520086.dis2filter(c,ec)
	return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_EFFECT) and c:GetAttack()<=ec:GetAttack() and c:GetDefense()<=ec:GetDefense()
end
function c21520086.dis2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c21520086.dis2filter(chkc) and e:GetHandler()~=chkc end
	if chk==0 then return Duel.IsExistingTarget(c21520086.dis2filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c21520086.dis2filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c21520086.dis2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and c:GetAttack()>=tc:GetAttack() and c:GetDefense()>=tc:GetDefense() then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e0:SetCode(EFFECT_UPDATE_ATTACK)
		e0:SetValue(-tc:GetAttack())
		c:RegisterEffect(e0)
		local e01=Effect.CreateEffect(c)
		e01:SetType(EFFECT_TYPE_SINGLE)
		e01:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e01:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e01:SetCode(EFFECT_UPDATE_DEFENSE)
		e01:SetValue(-tc:GetDefense())
		c:RegisterEffect(e01)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
