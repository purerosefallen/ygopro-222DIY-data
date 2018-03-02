--究极幻象 宇宙之羽
function c75646123.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(0x1)
	e1:SetProperty(0x20000)
	e1:SetRange(0x4)
	e1:SetCode(42)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(41)
	c:RegisterEffect(e2)
	--extra attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(0x1)
	e3:SetCode(194)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--battle
	local e4=Effect.CreateEffect(c)
	e4:SetType(0x1)
	e4:SetCode(202)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
