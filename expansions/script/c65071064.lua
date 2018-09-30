--闪金冲锋
function c65071064.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65071064,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65071064+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65071064.target)
	e1:SetOperation(c65071064.operation)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c65071064.deecon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65071064.deetg)
	e2:SetOperation(c65071064.deeop)
	c:RegisterEffect(e2)
end
function c65071064.deecon(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end

function c65071064.deefil(c)
	return c:IsCode(65071153)
end

function c65071064.deetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsCode(65071153) end
	if chk==0 then return Duel.IsExistingTarget(c65071064.deefil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectTarget(tp,c65071064.deefil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	local cg=tc:GetColumnGroup()
	cg:Merge(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,cg,1,0,0)
end

function c65071064.deeop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local cg=tc:GetColumnGroup()
		cg:AddCard(tc)
		if cg:GetCount()>0 then
			Duel.SendtoGrave(cg,REASON_EFFECT)
		end
	end
end

function c65071064.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c65071064.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,65071154,0,0x4011,2500,2000,8,RACE_SPELLCASTER,ATTRIBUTE_LIGHT,POS_FACEUP,tp) then return end
	local token=Duel.CreateToken(tp,65071154)
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
		 --destroy
		local e6=Effect.CreateEffect(c)
		e6:SetDescription(aux.Stringid(65071064,2))
		e6:SetCategory(CATEGORY_DESTROY+CATEGORY_COIN)
		e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e6:SetCode(EVENT_BATTLE_START)
		e6:SetCondition(c65071064.decon)
		e6:SetTarget(c65071064.detg)
		e6:SetOperation(c65071064.deop)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e7:SetRange(LOCATION_SZONE)
		e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e7:SetReset(RESET_EVENT+0x1fe0000)
		e7:SetTarget(c65071064.eftg)
		e7:SetLabelObject(e6)
		c:RegisterEffect(e7)
		--damage
		local e8=Effect.CreateEffect(c)
		e8:SetCategory(CATEGORY_DAMAGE)
		e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e8:SetCode(EVENT_BATTLE_DESTROYING)
		e8:SetCondition(c65071064.damcon)
		e8:SetTarget(c65071064.damtg)
		e8:SetOperation(c65071064.damop)
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e9:SetRange(LOCATION_SZONE)
		e9:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e9:SetReset(RESET_EVENT+0x1fe0000)
		e9:SetTarget(c65071064.eftg)
		e9:SetLabelObject(e8)
		c:RegisterEffect(e9)
end
function c65071064.decon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()~=nil
end
function c65071064.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0)
end
function c65071064.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if c==tc then tc=Duel.GetAttacker() end
	if not tc:IsRelateToBattle() then return end
	Duel.Destroy(tc,REASON_EFFECT)
end
function c65071064.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c65071064.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c65071064.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=tc:GetAttack()
		if dam<0 then dam=0 end
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end
function c65071064.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end