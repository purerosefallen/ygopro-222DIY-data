--德莱姆的花梦者
function c65060017.initial_effect(c)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--confirm
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c65060017.condition)
	e1:SetCost(c65060017.cost)
	e1:SetTarget(c65060017.target)
	e1:SetOperation(c65060017.operation)
	c:RegisterEffect(e1)
	--inoshikacho
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c65060017.accon)
	e2:SetValue(c65060017.aclimit)
	c:RegisterEffect(e2)
end

function c65060017.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttack()<=300
end
function c65060017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(200)
	c:RegisterEffect(e1)
end
function c65060017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end

function c65060017.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local h=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if h<1 then return end
	Duel.Draw(1-tp,1,REASON_EFFECT)
	Duel.BreakEffect()
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(p,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		local tc=sg:GetFirst()
		if tc:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c65060017.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			if Duel.SelectYesNo(tp,aux.Stringid(65060017,0)) then
				local g1=Duel.SelectMatchingCard(tp,c65060017.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
				if g1:GetCount()>0 then
					Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
		if tc:IsType(TYPE_SPELL) and Duel.IsExistingMatchingCard(c65060017.setfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			if Duel.SelectYesNo(tp,aux.Stringid(65060017,1)) then
				local g2=Duel.SelectMatchingCard(tp,c65060017.setfil,tp,LOCATION_DECK,0,1,1,nil,false)
				if g2:GetCount()>0 then
					Duel.SSet(tp,g2:GetFirst())
					Duel.ConfirmCards(1-tp,g2)
				end
			end
		end
		if tc:IsType(TYPE_TRAP) and Duel.IsPlayerCanDraw(tp,1) then
			if Duel.SelectYesNo(tp,aux.Stringid(65060017,2)) then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end

function c65060017.spfil(c,e,tp)
	return c:IsSetCard(0x6da4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function c65060017.setfil(c,ignore)
	return c:IsSetCard(0x6da4) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(ignore)
end

function c65060017.accon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttack()<=100
end

function c65060017.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE or re:GetActivateLocation()==LOCATION_REMOVED
end