--3L·Crimson Glory
local m=37564852
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)	
end
function cm.effect_operation_3L(c)
	local ex1=Effect.CreateEffect(c)
	ex1:SetType(EFFECT_TYPE_FIELD)
	ex1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ex1:SetRange(LOCATION_MZONE)
	ex1:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
	ex1:SetTargetRange(1,0)
	ex1:SetValue(1)
	ex1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(ex1,true)
	return ex1
end
function cm.filter(c)
	return not c:IsCode(m) and Senya.check_set_3L(c) and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()==1-tp
end
function cm.MergeCard(g,p,loc,seq)
	local tc=Duel.GetFieldCard(p,loc,seq)
	if tc then
		g:AddCard(tc)
		return true
	else
		return false
	end
end
function cm.GetCrossGroup(p,seq)
	local zone=(0x1f & ~(0x1 << seq)) | (0x0100 << seq) | (0x01010000 << 4-seq)
	if seq==1 then
		zone=zone | 0x00400020
	elseif seq==3 then
		zone=zone | 0x00200040
	end
	return Duel.GetCardsInZone(p,zone)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local res={}
		local zones={[0]=0,[1]=0}
		for p=0,1 do
			for seq=0,4 do
				local g=cm.GetCrossGroup(p,seq)
				if #g>0 then zones[p]=zones[p] | (0x1 << seq) end
			end
			res[p]=zones[p]>0 and Duel.GetMZoneCount(p,nil,tp,LOCATION_REASON_TOFIELD,zones[p])>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,p,zones[p])
		end
		return res[0] or res[1]
	end
	local g=Group.CreateGroup()
	for p=0,1 do
		for seq=0,4 do
			local tg=cm.GetCrossGroup(p,seq)
			if Duel.CheckLocation(p,LOCATION_MZONE,seq) then g:Merge(tg) end
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,#g*500)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local res={}
		local zones={[0]=0,[1]=0}
		for p=0,1 do
			for seq=0,4 do
				local g=cm.GetCrossGroup(p,seq)
				if #g>0 then zones[p]=zones[p] | (0x1 << seq) end
			end
			res[p]=zones[p]>0 and Duel.GetMZoneCount(p,nil,tp,LOCATION_REASON_TOFIELD,zones[p])>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,p,zones[p])
		end
		local sp=nil
		if res[0] and res[1] then
			sp=Duel.SelectOption(tp,m*16+2,m*16+3)==0 and tp or 1-tp
		elseif res[tp] then
			sp=tp
		elseif res[1-tp] then
			sp=1-tp
		else
			return
		end
		local z=zones[sp]
		if Duel.SpecialSummon(c,0,tp,sp,false,false,POS_FACEUP_ATTACK,z)>0 then
			Duel.Hint(HINT_MUSIC,0,m*16+4)
			local dg=cm.GetCrossGroup(sp,c:GetSequence())
			Duel.BreakEffect()
			local ct=Duel.Destroy(dg,REASON_EFFECT)
			Duel.Damage(1-tp,ct*500,REASON_EFFECT)
		end
	end
end